---
title: Benchmarking WSGI servers
tags: python
published: 2020-12-23 15:00:00
---

I've been using [flask][]'s built in WSGI server for [bookdb][] and
[bookmarks][] for a while now.  The very same built in server that it
warns you to not use in production because it scales badly.

But how badly?  Fortunately, the flask docs [list some better
servers][], so I decided to try out a few of them.

[flask]: https://flask.palletsprojects.com/en/1.1.x/
[bookdb]: https://bookdb.barrucadu.co.uk/search
[bookmarks]: https://bookmarks.barrucadu.co.uk/search
[list some better servers]: https://flask.palletsprojects.com/en/1.1.x/deploying/wsgi-standalone/


Testing methodology
-------------------

I decided to use [siege][], because it can take a list of URLs in a
text file.  I've got [some prior experience of Gatling][], but didn't
feel like writing Scala.

I produced a list of 30 bookdb URLs:

- 2 variations of the search page with no parameters (both HTML and JSON endpoints)
- 7 variations of the search page with parameters (all HTML)
- 1 book JSON endpoint
- 9 book cover images
- 9 book cover thumbnail images
- 2 static files (css and javascript)

And then I ran siege for 10s with 2, 4, and 8 workers, against:

- The default Werkzeug WSGI server
- [Gunicorn][], with 4 processes
- [uWSGI][], with 4 processes
- [Gevent][]

[siege]: https://github.com/JoeDog/siege
[some prior experience of Gatling]: https://github.com/alphagov/govuk-load-testing
[Gunicorn]: https://gunicorn.org/
[uWSGI]: https://uwsgi-docs.readthedocs.io/en/latest/
[Gevent]: http://www.gevent.org/


Results
-------

![Graph showing transaction rate for various servers and siege configurations.](benchmarking-wsgi-servers/transaction-rate.png)

The results are in, the default Werkzeug server is bad at scaling!
The number of transactions (completed requests) per second doesn't
really change, even when the number of siege workers (clients) goes up
by a factor of 4.  I suspect it's processing requests synchronously in
a single thread.

Every other server shows a good increase in throughput when the number
of clients goes up.  Though Gevent starts even slower than Werkzeug!

Gunicorn looks like a slight winner over uWSGI, so that's the server
I'll be using going forwards.


Appendix: raw data
------------------

### Werkzeug

```
+ siege -q -t 10S -c 2 -f urls.txt

{       "transactions":                         2309,
        "availability":                       100.00,
        "elapsed_time":                        10.00,
        "data_transferred":                     8.21,
        "response_time":                        0.01,
        "transaction_rate":                   230.90,
        "throughput":                           0.82,
        "concurrency":                          1.98,
        "successful_transactions":              2309,
        "failed_transactions":                     0,
        "longest_transaction":                  0.61,
        "shortest_transaction":                 0.00
}
+ siege -q -t 10S -c 4 -f urls.txt

{       "transactions":                         2648,
        "availability":                       100.00,
        "elapsed_time":                         9.99,
        "data_transferred":                     7.80,
        "response_time":                        0.01,
        "transaction_rate":                   265.07,
        "throughput":                           0.78,
        "concurrency":                          3.96,
        "successful_transactions":              2648,
        "failed_transactions":                     0,
        "longest_transaction":                  0.87,
        "shortest_transaction":                 0.00
}
+ siege -q -t 10S -c 8 -f urls.txt

{       "transactions":                         2503,
        "availability":                       100.00,
        "elapsed_time":                         9.98,
        "data_transferred":                    11.85,
        "response_time":                        0.03,
        "transaction_rate":                   250.80,
        "throughput":                           1.19,
        "concurrency":                          7.96,
        "successful_transactions":              2503,
        "failed_transactions":                     0,
        "longest_transaction":                  0.89,
        "shortest_transaction":                 0.01
}
```

### Gunicorn

```
+ siege -q -t 10S -c 2 -f urls.txt

{       "transactions":                         2833,
        "availability":                       100.00,
        "elapsed_time":                         9.11,
        "data_transferred":                     9.21,
        "response_time":                        0.01,
        "transaction_rate":                   310.98,
        "throughput":                           1.01,
        "concurrency":                          1.95,
        "successful_transactions":              2833,
        "failed_transactions":                     0,
        "longest_transaction":                  0.62,
        "shortest_transaction":                 0.00
}
+ siege -q -t 10S -c 4 -f urls.txt

{       "transactions":                         4175,
        "availability":                       100.00,
        "elapsed_time":                         9.98,
        "data_transferred":                    16.54,
        "response_time":                        0.01,
        "transaction_rate":                   418.34,
        "throughput":                           1.66,
        "concurrency":                          3.94,
        "successful_transactions":              4175,
        "failed_transactions":                     0,
        "longest_transaction":                  1.24,
        "shortest_transaction":                 0.00
}
+ siege -q -t 10S -c 8 -f urls.txt

{       "transactions":                         5665,
        "availability":                       100.00,
        "elapsed_time":                         9.98,
        "data_transferred":                    18.92,
        "response_time":                        0.01,
        "transaction_rate":                   567.64,
        "throughput":                           1.90,
        "concurrency":                          7.86,
        "successful_transactions":              5665,
        "failed_transactions":                     0,
        "longest_transaction":                  1.54,
        "shortest_transaction":                 0.00
}
```

### uWSGI

```
+ siege -q -t 10S -c 2 -f urls.txt

{       "transactions":                         2875,
        "availability":                       100.00,
        "elapsed_time":                         9.86,
        "data_transferred":                     9.46,
        "response_time":                        0.01,
        "transaction_rate":                   291.58,
        "throughput":                           0.96,
        "concurrency":                          1.97,
        "successful_transactions":              2875,
        "failed_transactions":                     0,
        "longest_transaction":                  0.58,
        "shortest_transaction":                 0.00
}
+ siege -q -t 10S -c 4 -f urls.txt

{       "transactions":                         3983,
        "availability":                       100.00,
        "elapsed_time":                         9.98,
        "data_transferred":                    16.38,
        "response_time":                        0.01,
        "transaction_rate":                   399.10,
        "throughput":                           1.64,
        "concurrency":                          3.94,
        "successful_transactions":              3983,
        "failed_transactions":                     0,
        "longest_transaction":                  1.03,
        "shortest_transaction":                 0.00
}
+ siege -q -t 10S -c 8 -f urls.txt

{       "transactions":                         5394,
        "availability":                       100.00,
        "elapsed_time":                         9.98,
        "data_transferred":                    16.36,
        "response_time":                        0.01,
        "transaction_rate":                   540.48,
        "throughput":                           1.64,
        "concurrency":                          7.91,
        "successful_transactions":              5394,
        "failed_transactions":                     0,
        "longest_transaction":                  1.32,
        "shortest_transaction":                 0.00
}
```

### Gevent

```
+ siege -q -t 10S -c 2 -f urls.txt

{       "transactions":                         2076,
        "availability":                       100.00,
        "elapsed_time":                         9.70,
        "data_transferred":                     7.91,
        "response_time":                        0.01,
        "transaction_rate":                   214.02,
        "throughput":                           0.82,
        "concurrency":                          1.97,
        "successful_transactions":              2076,
        "failed_transactions":                     0,
        "longest_transaction":                  0.65,
        "shortest_transaction":                 0.00
}
+ siege -q -t 10S -c 4 -f urls.txt

{       "transactions":                         2796,
        "availability":                       100.00,
        "elapsed_time":                         9.98,
        "data_transferred":                     8.97,
        "response_time":                        0.01,
        "transaction_rate":                   280.16,
        "throughput":                           0.90,
        "concurrency":                          3.96,
        "successful_transactions":              2796,
        "failed_transactions":                     0,
        "longest_transaction":                  0.63,
        "shortest_transaction":                 0.00
}
+ siege -q -t 10S -c 8 -f urls.txt

{       "transactions":                         3143,
        "availability":                       100.00,
        "elapsed_time":                         9.99,
        "data_transferred":                    12.68,
        "response_time":                        0.03,
        "transaction_rate":                   314.61,
        "throughput":                           1.27,
        "concurrency":                          7.95,
        "successful_transactions":              3143,
        "failed_transactions":                     0,
        "longest_transaction":                  0.59,
        "shortest_transaction":                 0.01
}
```

Appendix: urls.txt
------------------

```
http://127.0.0.1:3000/search
http://127.0.0.1:3000/search?keywords=flatland&author%5B%5D=&location=&match=&category=
http://127.0.0.1:3000/search?keywords=flatland&author%5B%5D=Ian+Stewart&location=&match=&category=
http://127.0.0.1:3000/search?keywords=&author%5B%5D=&location=f256ed66-4c09-4207-86de-adc8e9fb86ec&match=&category=
http://127.0.0.1:3000/search?keywords=&author%5B%5D=&location=f256ed66-4c09-4207-86de-adc8e9fb86ec&match=only-unread&category=
http://127.0.0.1:3000/search?keywords=Before+Dawn&author%5B%5D=&location=f256ed66-4c09-4207-86de-adc8e9fb86ec&match=only-unread&category=
http://127.0.0.1:3000/search?keywords=Before+AND+Dawn&author%5B%5D=&location=f256ed66-4c09-4207-86de-adc8e9fb86ec&match=only-unread&category=
http://127.0.0.1:3000/search?keywords=&author%5B%5D=Zzarchov+Kowolski&location=&match=only-read&category=70196ec9-dd61-4241-afc9-dd6be7be30a6
http://127.0.0.1:3000/search.json
http://127.0.0.1:3000/book/9780486272634
http://127.0.0.1:3000/book/9780486272634/cover
http://127.0.0.1:3000/book/9780262510875/cover
http://127.0.0.1:3000/book/9780575082014/cover
http://127.0.0.1:3000/book/9780575079793/cover
http://127.0.0.1:3000/book/9780141397726/cover
http://127.0.0.1:3000/book/9780575086159/cover
http://127.0.0.1:3000/book/9780199535644/cover
http://127.0.0.1:3000/book/9780575077324/cover
http://127.0.0.1:3000/book/9781421578798/cover
http://127.0.0.1:3000/book/9780486272634/thumb
http://127.0.0.1:3000/book/9780262510875/thumb
http://127.0.0.1:3000/book/9780575082014/thumb
http://127.0.0.1:3000/book/9780575079793/thumb
http://127.0.0.1:3000/book/9780141397726/thumb
http://127.0.0.1:3000/book/9780575086159/thumb
http://127.0.0.1:3000/book/9780199535644/thumb
http://127.0.0.1:3000/book/9780575077324/thumb
http://127.0.0.1:3000/book/9781421578798/thumb
http://127.0.0.1:3000/static/style.css
http://127.0.0.1:3000/static/script.js
```

Appendix: graph script
----------------------

```python
#! /usr/bin/env nix-shell
#! nix-shell -i python -p "python3.withPackages (ps: [ps.matplotlib ps.numpy])"

import matplotlib.pyplot as plt
import numpy as np

plt.xkcd()
plt.figure(figsize=(12,6))

labels = ["Werkzeug", "Gunicorn", "uWSGI", "Gevent"]
bars = [("2 workers", [230.90, 310.98, 291.58, 214.02]),
        ("4 workers", [265.07, 418.34, 399.10, 280.16]),
        ("8 workers", [250.80, 567.64, 540.48, 314.61])]

bar_width = 0.25

rs = [np.arange(len(labels))]
for i in range(len(bars)-1):
    rs.append([x + bar_width for x in rs[-1]])

for i in range(len(bars)):
    plt.bar(rs[i], bars[i][1], width=bar_width, label=bars[i][0])

plt.ylabel("Transactions per second (higher is better)")
plt.xlabel("Server")
plt.xticks([r + bar_width for r in range(len(labels))], labels)

plt.legend()
plt.savefig("transaction-rate.png")
```
