---
title: Processing 100GB of nginx logs
tags: gov.uk, tech
date: 2018-10-22
audience: General
---

I wanted to know two slightly different things about traffic to
GOV.UK:

* What is the busiest minute (in terms of number of `GET` requests) we
  have on record; and
* For each path, what is the busiest minute for that path?

Time to look at the nginx logs!


Aggregating nginx logs
----------------------

We have a daily log rotation of our nginx logs, and keep 28 prior
versions.  To add to the fun, there are three machines running nginx;
so requests for the same minute will typically be spread over three
different files (one for each machine), but up to six (if the minute
coincides with log rotation).

But this is not an insurmountable problem.  Let's download them all
and produce a single aggregate file containing all of the data:

```
$ mkdir cache-1
$ mkdir cache-2
$ mkdir cache-3
$ scp cache-1.production:/var/log/nginx/lb-access.log.{1,{2..28}.gz} cache-1
$ scp cache-2.production:/var/log/nginx/lb-access.log.{1,{2..28}.gz} cache-2
$ scp cache-3.production:/var/log/nginx/lb-access.log.{1,{2..28}.gz} cache-3
```

Time passes.

```
$ gunzip cache-*/*.gz
$ du -shc cache-*
 35G    cache-1
 35G    cache-2
 35G    cache-3
105G    total
```

That's a bit much to read into memory in one go.  So let's change tack
and instead extract just the information we want (`GET` requests) from
*each* log file, and then aggregate all that data.

Our nginx logs are using this format:

```
log_format timed_combined '$remote_addr - $remote_user [$time_local]  '
  '"$request" $status $body_bytes_sent '
  '"$http_referer" "$http_user_agent" '
  '$request_time $upstream_response_time '
  '$gzip_ratio $sent_http_x_cache $sent_http_location $http_host '
  '$ssl_protocol $ssl_cipher';
```

This is a space-separated list of fields.  We're only interested in
the initial portion of this which looks like this:

```
ip_address - - [timestamp]  "GET path HTTP/1.1" rest...
```

Fortunately, Ruby's csv module is flexible enough to let you use space
as a separator character for fields.  So we can treat an nginx log
file as a csv:

```ruby
require 'csv'

CSV.foreach(filename, headers: false, col_sep: ' ') do |request|
  ...
end
```

The `CSV.foreach` function reads one line of the csv file at a time,
which is handy when our files are big.

We want the number of requests to a given path in a given minute, so a
csv in the form `"path", "rounded timestamp", "hits"` seems like a
good output fomat.  In which case, a map `path -> timestamp -> hits`
seems like a great choice of data structure.  We can read our csv into
that:


```ruby
require 'csv'

# pass filenames on the command line, so we can run this for each log
# file
outfname = ARGV.shift
infname = ARGV.shift

paths = {}
puts "reading #{infname}"
CSV.foreach(infname, headers: false, col_sep: ' ') do |request|
  # extract the bits of the request that we want
  time = DateTime.strptime(request[3], '[%d/%b/%Y:%H:%M:%S')
  req_bits = request[5].split(' ')

  # only count GET requests
  method = req_bits[0]
  next unless method == 'GET'

  # round the timestamp down to the minute
  bucket = time.strftime('%Y-%m-%d %H:%M')

  # strip query string from the path
  path = req_bits[1].split('?')[0]

  # skip uploaded files
  next if path.start_with? '/government/uploads'

  # increment the count for this (path, bucket) pair
  paths[path] = {} unless paths.has_key? path
  paths[path][bucket] = 1 + paths[path].fetch(bucket, 0)
end
```

I've called the rounded timestamp the "bucket", as in principle we
could round to periods other than one minute.  From this point on I'll
talk about buckets, not minutes.

Now we want to write out that data to a new file:

```ruby
puts "writing #{outfname}"
CSV.open(outfname, 'w', force_quotes: true) do |csv|
  paths.each do |path, buckets|
    buckets.each do |bucket, hits|
      csv << [path, bucket, hits]
    end
  end
end
```

As you might hope, these csv files are smaller than the original log
files:

```
$ du -h cache-1/lb-access.log.1{,.csv}
1.4G    cache-1/lb-access.log.1
209M    cache-1/lb-access.log.1.csv

$ wc -l cache-1/lb-access.log.1{,.csv}
 3828632 cache-1/lb-access.log.1
 2197194 cache-1/lb-access.log.1.csv
```

The dramatic difference in file size is mostly because of all the
extra data for each log entry which has been thrown out.

If we just wanted to work out the busiest bucket (and the paths hit in
that bucket), we could stop here.  However, when working out the
busiest bucket for each path, it will be handy if all the data is
grouped by path.  So let's combine the files, with that grouping:

```bash
# sort each file, which in practice groups by path and then bucket
for f in cache-*/*.csv; do
  sort -o $f.sorted $f
  mv $f.sorted $f
done

# for each machine, merge all its sorted files
for d in cache-*; do
  sort -m -o $d/cache-logs.csv $d/*.csv
done

# merge the files for each machine into one big file
sort -m -o cache-logs.csv cache-*/cache-logs.csv
```

In the final file, there are 160,404,944 lines.  I decided to sort the
smaller files because merging sorted files is linear time, so we get
these complexities:

* `O([max size of individual file] * log [max size of individual file] + [combined size of all files])` for sorting and then combining
* `O([combined size of all files] * log [combined size of all files] + [combined size of all files])` for combining and then sorting

Having said that, `sort` is pretty good, and I didn't benchmark, so
this may be a totally unneeded optimisation.

Notice that I'm not merging entries for the same path-and-timestamp,
so in general there may be multiple entries for each:

```
$ grep '"/"' cache-logs.csv | grep "2018-09-21 05:44"
"/","2018-09-21 05:44","1"
"/","2018-09-21 05:44","1"
```

This is fine, we can account for it when working out the information
we need.


Finding the busiest minute, overall
-----------------------------------

Our `cache-logs.csv` file has way too much data to keep in memory all
at once, so I decided to adopt a two-pass approach for this.  First we
read through the file to work out the total number of hits for each
bucket, then we read through the file again to get the paths for the
biggest bucket.  This is a little slow, and there's probably a better
way of doing this (like maybe not having a 15GB, 160-million-line, csv
file), but it works.

First, we work out the most-hit bucket:

```ruby
require 'csv'

outfname = ARGV.shift
infname = ARGV.shift

hit_threshold = 3

buckets = {}
puts "[pass 1] reading #{infname}"
CSV.foreach(infname) do |row|
  # we don't care about the path here, just the bucket and hits
  bucket = row[1]
  hits = row[2].to_i

  # skip things hit under the threshold
  next if hits < hit_threshold

  # increment the count for this bucket
  buckets[bucket] = hits + buckets.fetch(bucket, 0)
end

# the most-hit bucket
top_bucket, _ = buckets.max_by { |_, h| h }
```

I've decided to exclude paths which were hit under three times from
the total, as that prevents the results from being skewed too much by
people who automatically scan the site to find vulnerabilities.

And now we can find the paths for the most-hit bucket:

```ruby
paths = {}
puts "[pass 2] reading #{infname}"
CSV.foreach(infname) do |row|
  path = row[0]
  bucket = row[1]
  hits = row[2].to_i

  next unless bucket == top_bucket

  # remember we're skipping things below our threshold
  next if hits < hit_threshold

  paths[path] = hits + paths.fetch(path, 0)
end
```

We might get multiple entries for the same path in the same bucket,
which is why we have to *add* the number of hits, rather than just
recording it.  This is because we didn't do any deduplication of our
`cache-logs.csv` file.

Finally we write out the paths:

```ruby
puts "writing #{outfname}"
CSV.open(outfname, 'w', force_quotes: true) do |csv|
  paths.each do |path, hits|
    csv << [path, top_bucket, hits]
  end
end
```


Finding the busiest minute, for each path
-----------------------------------------

The entries of `cache-logs.csv` are sorted by path, so we can do this
in one pass.  We read through the file, keeping track of all the
buckets for the current path, and when the path changes we record the
busiest bucket for the old path.

This script is kind of like a combination of the two we've seen so
far.  We're going to build up a map of paths in memory, working out
what the busiest bucket is at each step:

```ruby
require 'csv'

outfname = ARGV.shift
infname = ARGV.shift

# paths processed so far
paths = {}

# the path we're currently inspecting
current_path = nil

# buckets for the current path
buckets = {}

puts "reading #{infname}"
CSV.foreach(infname) do |row|
  path = row[0]
  bucket = row[1]
  hits = row[2]

  # special case for the first row
  current_path = path if current_path.nil?

  # if we're changing path...
  unless path == current_path
    # work out the top bucket for the old path
    top_bucket, top_hits = buckets.max_by { |_, h| h }

    # record the top bucket and its hits
    paths[current_path] = [top_bucket, top_hits]

    # and advance to the next path
    current_path = path
    buckets = {}
  end

  buckets[bucket] = hits.to_i + buckets.fetch(bucket, 0)
end
```

Once again, we then write the output to a new csv file:

```ruby
puts "writing #{outfname}"
CSV.open(outfname, 'w', force_quotes: true) do |csv|
  paths.each do |path, info|
    bucket = info[0]
    hits = info[1]
    csv << [path, bucket, hits]
  end
end
```

We could avoid storing all the paths in memory, by writing out a row
each time we change path, but I like the separation between input and
output.  Even with 4,178,052 paths, the memory usage is nothing to
worry about.


What did we learn?
------------------

There are a few things which I learned while doing this.  The most
surprising is that barely any traffic makes it though our CDN to our
origin servers!

The period I have logs for covers some brexit publishing, which I'd
have expected to significantly increase traffic.  But the busiest
minute (2018-10-17 15:53) has something like 60 hits per second, which
is not a lot at all.

On the other hand, perhaps this is showing that a minute is too small
a resolution to look at, maybe it would be a very different story with
five-minute buckets, or hour buckets.

Another thing I learned is that there are a lot of requests trying to
do SQL injection through the request path:

```
$ grep select top-bucket-foreach-path.csv | grep from | wc -l
80680

$ grep select top-bucket-foreach-path.csv | grep from | head -n5
"/%20or%20(1,2)=(select*from(select%20name_const(CHAR(102,89,117,118,67,113,78,109,82,121,88),1),name_const(CHAR(102,89,117,118,67,113,78,109,82,121,88),1))a)%20--%20and%201%3D1","2018-10-18 12:33","1"
"/%20or%20(1,2)=(select*from(select%20name_const(CHAR(105,109,74,71,119,74,71,115,78,79,73,70),1),name_const(CHAR(105,109,74,71,119,74,71,115,78,79,73,70),1))a)%20--%20and%201%3D1","2018-10-17 15:51","1"
"/%20or%20(1,2)=(select*from(select%20name_const(CHAR(105,74,71,109,119,101,90,75,86),1),name_const(CHAR(105,74,71,109,119,101,90,75,86),1))a)%20--%20and%201%3D1","2018-10-13 14:39","1"
"/%20or%20(1,2)=(select*from(select%20name_const(CHAR(106,86,82,86,80,106,97,114,80,106),1),name_const(CHAR(106,86,82,86,80,106,97,114,80,106),1))a)%20--%20and%201%3D1","2018-10-14 12:31","1"
"/%20or%20(1,2)=(select*from(select%20name_const(CHAR(108,75,105,74,79,73,109,114,68),1),name_const(CHAR(108,75,105,74,79,73,109,114,68),1))a)%20--%20and%201%3D1","2018-10-17 19:19","1"
```

I suspect if I wasn't cutting off query strings, there would be a lot
more SQL injection visible.

But the main thing I learned is that this is probably a situation
where I should not have used a csv file.  It took me a few iterations
to work out exactly what I needed, and that meant regenerating
everything (which takes a few hours) several times.  If I'd just split
up each request into fields and dumped them into a database, it would
probably have been faster and easier to iterate.
