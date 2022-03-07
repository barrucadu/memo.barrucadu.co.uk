---
title: Implementing a size-bounded LRU cache with expiring entries for my DNS server (in Rust)
taxon: general
published: 2022-03-07
---

I've spent the last week or so implementing [a recursive DNS
resolver][] in Rust.  I'm not very good at either of those things, so
this has been a bit of a learning experience.

[a recursive DNS resolver]: https://github.com/barrucadu/resolved

This memo is about how I ended up implementing the caching layer.  You
don't need to know much about DNS to follow this memo, just some
basics:

- DNS is a distributed eventually-consistent database, and timeouts
  are how it achieves that eventual consistency.
- The keys in this database are **domain names** (like
  `www.barrucadu.co.uk`) and the values are **resource records** (RRs
  for short).
- A resource record has a **type** (like "A", or "CNAME"), a **class**
  (like "IN", for INternet), a **ttl** (how long it's valid for), and
  some **data**.
- Finally, the format of that data depends on the type (but not on the
  class).

Let's make this a bit more concrete:

```rust
// we'll need these later
use priority_queue::PriorityQueue;
use std::cmp::Reverse;
use std::collections::HashMap;
use std::net::Ipv4Addr;
use std::time::{Duration, Instant};

/// A resource record, or RR, is something we receive from another
/// nameserver, or which we send in answer to a client's query.
#[derive(Debug)]
pub struct ResourceRecord {
    pub name: DomainName,
    pub rtype: RecordTypeWithData,
    pub rclass: RecordClass,
    pub ttl: Duration,
}

/// A domain name is a sequence of "labels", eg, `www.barrucadu.co.uk`
/// is made up of the labels `["www", "barrucadu", "co", "uk", ""]`.
/// The final empty label is the root domain, which we normally don't
/// bother writing, but is meaningful in some contexts.
///
/// Incidentally, the final empty label means that in the DNS wire
/// format, names are null-terminated.  I'm sure this isn't a
/// coincidence.
///
/// Labels are ASCII and case-insensitive, so make sure to construct
/// them correctly!
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct DomainName {
    pub labels: Vec<Vec<u8>>,
}

/// Record data depends on its type, so this enum has one variant for
/// each type.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum RecordTypeWithData {
    A { address: Ipv4Addr },
    CNAME { cname: DomainName }, // many more omitted
}

/// We'll also need a notion of record type *without* data.
#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
pub enum RecordType {
    A,
    CNAME, // many more omitted
}

impl RecordTypeWithData {
    pub fn rtype(&self) -> RecordType {
        match self {
            RecordTypeWithData::A { .. } => RecordType::A,
            RecordTypeWithData::CNAME { .. } => RecordType::CNAME,
            // many more omitted
        }
    }
}

/// The record class identifies which sort of network the record is
/// for.  For the purposes of this memo, let's only consider the
/// internet.
#[derive(Debug, Copy, Clone, PartialEq, Eq)]
pub enum RecordClass {
    IN,
}
```

Before we go any further, there's one final prerequisite.  When you
ask a DNS server for some records, you don't say,

> Give me all records of such-and-such record type and record class
> for `www.barrucadu.co.uk`.

You instead ask in terms of a **query type** and **query class**.

In this memo, you can think of those as just the record types and
classes we've just defined, plus a wildcard to mean "match anything":

```rust
#[derive(Debug, Copy, Clone)]
pub enum QueryType {
    Record(RecordType),
    Wildcard,
}

// does a record match a query, or a query match a record?  this is
// the way 'round I went for, but the other choice would make just as
// much sense.
impl RecordType {
    pub fn matches(&self, qtype: &QueryType) -> bool {
        match qtype {
            QueryType::Wildcard => true,
            QueryType::Record(rtype) => rtype == self,
        }
    }
}

#[derive(Debug, Copy, Clone)]
pub enum QueryClass {
    Record(RecordClass),
    Wildcard,
}

impl RecordClass {
    pub fn matches(&self, qclass: &QueryClass) -> bool {
        match qclass {
            QueryClass::Wildcard => true,
            QueryClass::Record(rclass) => rclass == self,
        }
    }
}
```

There are a few more in reality, but they're not important for our
purposes.

So we'll use the `Record*` types to **put** values into the cache and
the `Query*` types to **get** values from the cache.


## A Simple Cache

Right, what's the simplest possible cache we could implement?

Perhaps something like this:[^fn]

[^fn]: Not just "perhaps": this is more-or-less copied straight from
    my original code.

```rust
pub struct SimpleCache {
    entries: HashMap<DomainName, Vec<(RecordTypeWithData, RecordClass, Instant)>>,
}

impl SimpleCache {
    pub fn new() -> Self {
        Self {
            entries: HashMap::new(),
        }
    }
```

To put something in the cache, you just add it to the appropriate
`Vec`:

```rust
    pub fn insert(&mut self, name: &DomainName, rr: ResourceRecord) {
        let entry = (rr.rtype, rr.rclass, Instant::now() + rr.ttl);
        if let Some(entries) = self.entries.get_mut(name) {
            entries.push(entry);
        } else {
            self.entries.insert(name.clone(), vec![entry]);
        }
    }
```

What if the user inserts the same record twice?

Well, what about it?  This is a proof-of-concept!  The DNS resolver
will return duplicate records I guess!  Moving swiftly on...

To get something from the cache, just iterate over the appropriate
`Vec`, pulling out all the records with the right type and class:

```rust
    pub fn get(
        &self,
        name: &DomainName,
        qtype: QueryType,
        qclass: QueryClass,
    ) -> Vec<ResourceRecord> {
        let now = Instant::now();
        if let Some(entries) = self.entries.get(name) {
            let mut rrs = Vec::with_capacity(entries.len());
            for (rtype_with_data, rclass, expires) in entries {
                if rtype_with_data.rtype().matches(&qtype) && rclass.matches(&qclass) {
                    rrs.push(ResourceRecord {
                        name: name.clone(),
                        rtype: rtype_with_data.clone(),
                        rclass: *rclass,
                        ttl: expires.saturating_duration_since(now),
                    });
                }
            }
            rrs
        } else {
            Vec::new()
        }
    }
}
```

What if a record has expired?

Proof-of-concept!  The caller can deal with that by checking
expiration times or something!

So, this was the caching implementation I started with.  It works, but
it has some problems:

- There's no deduplication.
- There's no expiration.
- There's no limit on the number of records.
- All domains get put in one `HashMap`, totally ignoring their
  hierarchical label structure.
- Getting records of one type involves iterating through records of
  another type.

But it's better than no cache!


## A Better Cache

Ok, how do we do better?  The most egregious problems with the simple
cache are the duplicate entries and the unbounded growth.

Using something that takes the hierarchical structure of domain names
into account, like a trie, would also be nice, but I'm not dealing
with enough live cache entries for that to be a concern yet.

So, how do we remove entries?

Well, we could periodically iterate over the entire cache, removing
all expired entries.  But if entries have a long expiration time, or
just get accessed frequently enough, they won't expire.  So relying on
expiration isn't enough, we also need to occasionally remove *live*
entries.

This sounds like a job for an LRU[^lru] cache: a size-bounded LRU
cache with expiring entries for my DNS server!

[^lru]: Least Recently Used

Before jumping straight to the `struct` definition, let's think about
how to model this:

- To solve the problem of iterating through records of unrelated
  types, we'll need to subdivide the entries by type as well as domain
  name.

- We'll need to keep track of the most recent time each record has
  been accessed, so when the cache is full of unexpired records we can
  work out which one to evict first.

- But the cache may be big.  There could be hundreds or thousands of
  domains in there, each likely with multiple records.  Iterating
  through the whole thing to find records to evict is a bad choice.
  We need a more efficient data structure to map from eviction
  priority to domain name.

- For similar reasons, we don't want to have to iterate through the
  entire cache to work out how big it is.

My usual mantra for designing data structures is to "make illegal
states unrepresentable", but I don't think that will work here.  To
make this cache *efficient*, we'll need to denormalise the data, and
make our code ensure the correct invariants hold.  Testing helps with
this (and indeed testing did find some bugs in my implementation).

So I decided to use a pair of priority queues[^pq] to efficiently
track (1) which domain is next to have an expiring record, and (2)
which domain has been least recently used.  I also decided to keep
track of sizes and times throughout the data structure, rather than
just in the records.

[^pq]: From the [priority-queue][] crate.  I started out trying to
    build something on top of [`std::collections::BinaryHeap`][]
    directly, but didn't get very far.

[priority-queue]: https://crates.io/crates/priority_queue
[`std::collections::BinaryHeap`]: https://doc.rust-lang.org/stable/std/collections/struct.BinaryHeap.html

Here's the new cache data structure:

```rust
#[derive(Debug)]
pub struct BetterCache {
    /// Cached records, indexed by domain name.
    entries: HashMap<DomainName, CachedDomainRecords>,

    /// Priority queue of domain names ordered by access times.
    ///
    /// When the cache is full and there are no expired records to
    /// prune, domains will instead be pruned in LRU order.
    ///
    /// INVARIANT: the domains in here are exactly the domains in
    /// `entries`.
    access_priority: PriorityQueue<DomainName, Reverse<Instant>>,

    /// Priority queue of domain names ordered by expiry time.
    ///
    /// When the cache is pruned, expired records are removed first.
    ///
    /// INVARIANT: the domains in here are exactly the domains in
    /// `entries`.
    expiry_priority: PriorityQueue<DomainName, Reverse<Instant>>,

    /// The number of records in the cache.
    ///
    /// INVARIANT: this is the sum of the `size` fields of the
    /// entries.
    current_size: usize,

    /// The desired maximum number of records in the cache.
    desired_size: usize,
}

#[derive(Debug)]
struct CachedDomainRecords {
    /// The time this record was last read at.
    last_read: Instant,

    /// When the next RR expires.
    ///
    /// INVARIANT: this is the minimum of the expiry times of the RRs.
    next_expiry: Instant,

    /// How many records there are.
    ///
    /// INVARIANT: this is the sum of the vector lengths in `records`.
    size: usize,

    /// The records, further divided by record type.
    ///
    /// INVARIANT: the `RecordType` and `RecordTypeWithData` match.
    records: HashMap<RecordType, Vec<(RecordTypeWithData, RecordClass, Instant)>>,
}

impl BetterCache {
    pub fn new() -> Self {
        Self::with_desired_size(512)
    }

    pub fn with_desired_size(desired_size: usize) -> Self {
        if desired_size == 0 {
            panic!("cannot create a zero-size cache");
        }

        Self {
            // `desired_size / 2` is a compromise: most domains will
            // have more than one record, so `desired_size` would be
            // too big for the `entries`.
            entries: HashMap::with_capacity(desired_size / 2),
            access_priority: PriorityQueue::with_capacity(desired_size),
            expiry_priority: PriorityQueue::with_capacity(desired_size),
            current_size: 0,
            desired_size,
        }
    }
```

There are some invariants there in the comments.  I'd prefer not to
have those, but I don't think there's any getting around it given that
we want better than linear time eviction.

This is substantially more complex than the `SimpleCache`, and the
operations we're about to define on it are too.  Make sure this all
makes sense before continuing.  In particular, you might notice that
I've opted to have the LRU eviction expire entire domain names, rather
than individual records within them.

Let's go through the new operations in order of complexity: querying,
eviction, and insertion.

### Getting things out

This isn't too bad:

```rust
    /// Get an entry from the cache.
    ///
    /// The TTL in the returned `ResourceRecord` is relative to the
    /// current time - not when the record was inserted into the
    /// cache.
    ///
    /// This entry may have expired: if so, the TTL will be 0.
    /// Consumers MUST check this before using the record!
    pub fn get(
        &mut self,
        name: &DomainName,
        qtype: &QueryType,
        qclass: &QueryClass,
    ) -> Vec<ResourceRecord> {
        if let Some(entry) = self.entries.get_mut(name) {
            let now = Instant::now();
            let mut rrs = Vec::new();
            match qtype {
                QueryType::Wildcard => {
                    for tuples in entry.records.values() {
                        to_rrs(name, qclass, now, tuples, &mut rrs);
                    }
                }
                QueryType::Record(rtype) => {
                    if let Some(tuples) = entry.records.get(rtype) {
                        to_rrs(name, qclass, now, tuples, &mut rrs);
                    }
                }
            }
            if !rrs.is_empty() {
                entry.last_read = now;
                self.access_priority
                    .change_priority(name, Reverse(entry.last_read));
            }
            rrs
        } else {
            Vec::new()
        }
    }
}
```

This is quite similar to what we had before.  Sure, the extra layer of
indirection adds a tad more complication, and there's now a write
operation in here (updating `last_read` and `access_priority`, which
takes log time), but other than that nothing complex.

The `to_rrs` function just exists to prevent some code duplication:

```rust
/// Helper for `get_without_checking_expiration`: converts the cached
/// record tuples into RRs.
fn to_rrs(
    name: &DomainName,
    qclass: &QueryClass,
    now: Instant,
    tuples: &[(RecordTypeWithData, RecordClass, Instant)],
    rrs: &mut Vec<ResourceRecord>,
) {
    for (rtype, rclass, expires) in tuples {
        if rclass.matches(qclass) {
            rrs.push(ResourceRecord {
                name: name.clone(),
                rtype: rtype.clone(),
                rclass: *rclass,
                ttl: expires.saturating_duration_since(now),
            });
        }
    }
}
```

If you're following along at home, put that definition *outside* the
`impl BetterCache` block.

### Evicting things

Here's are the simplest three functions in the entire `impl`:

```rust
    /// Delete all expired records, and then enough
    /// least-recently-used records to reduce the cache to the desired
    /// size.
    ///
    /// Returns the number of records deleted.
    pub fn prune(&mut self) -> usize {
        if self.current_size <= self.desired_size {
            return 0;
        }

        let mut pruned = self.remove_expired();

        while self.current_size > self.desired_size {
            pruned += self.remove_least_recently_used();
        }

        pruned
    }

    /// Helper for `prune`: deletes all records associated with the
    /// least recently used domain.
    ///
    /// Returns the number of records removed.
    fn remove_least_recently_used(&mut self) -> usize {
        if let Some((name, _)) = self.access_priority.pop() {
            self.expiry_priority.remove(&name);

            if let Some(entry) = self.entries.remove(&name) {
                let pruned = entry.size;
                self.current_size -= pruned;
                pruned
            } else {
                0
            }
        } else {
            0
        }
    }

    /// Delete all expired records.
    ///
    /// Returns the number of records deleted.
    pub fn remove_expired(&mut self) -> usize {
        let mut pruned = 0;

        loop {
            let before = pruned;
            pruned += self.remove_expired_step();
            if before == pruned {
                break;
            }
        }

        pruned
    }
```

So simple!  So straightforward!  If only all my code could be like
this.

- `prune` shrinks the cache to the desired size by removing the
  expired entries and then removing enough domains (in LRU order) to
  get below the target.

- `remove_least_recently_used` pops an entry from the
  `access_priority` queue, removes it from the `expiry_priority` queue
  (which takes log time), and deletes it from the top-level `entries`
  map.  It also updates the `current_size`, and returns the number of
  records it just deleted.

- `remove_expired` is deceptively simple.  It looks easy at first
  glance, but it's calling this `remove_expired_step` function in a
  loop, until no more get removed.

Removing an entire domain is easy, but removing individual records
from a domain is harder:

- The `size` of the domain will change.
- The `next_expiry` of the domain may change.
- Those changes need to be reflected in the top-level `current_size`
  and `expiry_priority` fields.
- But if it's the last record in the domain we should remove that
  entirely.

Additionally, the queue gives us the domain name, and there may be one
or more expiring records in it (or even zero, but that would be a
bug).

With all that said, here's the implementation:

```rust
    /// Helper for `remove_expired`: looks at the next-to-expire
    /// domain and cleans up expired records from it.  This may delete
    /// more than one record, and may even delete the whole domain.
    ///
    /// Returns the number of records removed.
    fn remove_expired_step(&mut self) -> usize {
        if let Some((name, Reverse(expiry))) = self.expiry_priority.pop() {
            let now = Instant::now();

            if expiry > now {
                self.expiry_priority.push(name, Reverse(expiry));
                return 0;
            }

            if let Some(entry) = self.entries.get_mut(&name) {
                let mut pruned = 0;

                let rtypes = entry.records.keys().cloned().collect::<Vec<RecordType>>();
                let mut next_expiry = None;
                for rtype in rtypes {
                    if let Some(tuples) = entry.records.get_mut(&rtype) {
                        let len = tuples.len();
                        tuples.retain(|(_, _, expiry)| expiry > &now);
                        pruned += len - tuples.len();
                        for (_, _, expiry) in tuples {
                            match next_expiry {
                                None => next_expiry = Some(*expiry),
                                Some(t) if *expiry < t => next_expiry = Some(*expiry),
                                _ => (),
                            }
                        }
                    }
                }

                entry.size -= pruned;

                if let Some(ne) = next_expiry {
                    entry.next_expiry = ne;
                    self.expiry_priority.push(name, Reverse(ne));
                } else {
                    self.entries.remove(&name);
                    self.access_priority.remove(&name);
                }

                self.current_size -= pruned;
                pruned
            } else {
                self.access_priority.remove(&name);
                0
            }
        } else {
            0
        }
    }
```

It's pretty complex.  We could describe it in pseudocode like so:

1. Pop the next expiring domain from the queue.
2. Check the current time:
   - If the expiry time is in the future, put it back in the queue and
     return.
   - Otherwise, get the cached records:
     - If there are no cached records, remove the domain from the
       access queue and return.
     - Otherwise:
       1. Iterate through all the records and check if each should
          expire:
           - If so, remove the record.
           - Otherwise, keep track of the soonest future expiry time seen.
       2. Check if this removed all the records:
          - If so, remove the domain from the cache.
          - Otherwise, put it back in the expiry queue with the new
            expiry time.
       3. Update the size fields.

In outline, fairly simple.  In implementation, not fairly simple.
Maybe someone better at Rust would be able to write this in a clearer
way, but this is what I've got.

Incidentally, one of the bugs found by testing (by inserting randomly
generated entries, pruning the expired ones, and checking the
invariants) was that I had that `entry.size -= pruned;` *inside* the
`for rtype in rtypes`, which means that if a domain had multiple
records *of different types* expire at the same time, the size would
be wrong.

### Putting things in

Unfortunately, this is the most complex part.  Adding a new entry to
our cache involves a lot of work to maintain those invariants,
especially if we also want to handle duplicate entries.

So before getting to the code, let's think about what the behaviour
should be.

1. If the domain name isn't in the cache at all, we need to:
   - Insert a `CachedDomainRecords` containing *just* our new record.
   - Add the domain to the `access_priority` queue.
   - Add the domain to the `expiry_priority` queue.

2. If the domain name is in the cache but it has no records of this
   type, we need to:
   - Add the record to the existing domain.
   - Update the domain's `size` and `last_read`.
   - Update the `access_priority` queue.
   - Update the domain's `next_expiry` and the `expiry_priority`
     queue, if this new record expires sooner than the current
     soonest.

3. If the domain name is in the cache and it does have records of this
   type, we need to:
   - Check if there is a duplicate record, and if so:
     - Delete it.
     - Decrement the domain's `size` and the `current_size`.
     - Update the domain's `next_expiry` and the `expiry_priority`
       queue if the duplicate would have been the soonest record to
       expire.
   - Then, the same as in case (2).

Additionally, in all cases, we need to increment the `current_size`.

Got all that?  Here's the code:

```rust
    /// Insert an entry into the cache.
    pub fn insert(&mut self, record: &ResourceRecord) {
        let now = Instant::now();
        let rtype = record.rtype.rtype();
        let expiry = Instant::now() + record.ttl;
        let tuple = (record.rtype.clone(), record.rclass, expiry);
        if let Some(entry) = self.entries.get_mut(&record.name) {
            if let Some(tuples) = entry.records.get_mut(&rtype) {
                let mut duplicate_expires_at = None;
                for i in 0..tuples.len() {
                    let t = &tuples[i];
                    if t.0 == tuple.0 && t.1 == tuple.1 {
                        duplicate_expires_at = Some(t.2);
                        tuples.swap_remove(i);
                        break;
                    }
                }

                tuples.push(tuple);

                if let Some(dup_expiry) = duplicate_expires_at {
                    entry.size -= 1;
                    self.current_size -= 1;

                    if dup_expiry == entry.next_expiry {
                        let mut new_next_expiry = expiry;
                        for (_, _, e) in tuples {
                            if *e < new_next_expiry {
                                new_next_expiry = *e;
                            }
                        }
                        entry.next_expiry = new_next_expiry;
                        self.expiry_priority
                            .change_priority(&record.name, Reverse(entry.next_expiry));
                    }
                }
            } else {
                entry.records.insert(rtype, vec![tuple]);
            }
            entry.last_read = now;
            entry.size += 1;
            self.access_priority
                .change_priority(&record.name, Reverse(entry.last_read));
            if expiry < entry.next_expiry {
                entry.next_expiry = expiry;
                self.expiry_priority
                    .change_priority(&record.name, Reverse(entry.next_expiry));
            }
        } else {
            let mut records = HashMap::new();
            records.insert(rtype, vec![tuple]);
            let entry = CachedDomainRecords {
                last_read: now,
                next_expiry: expiry,
                size: 1,
                records,
            };
            self.access_priority
                .push(record.name.clone(), Reverse(entry.last_read));
            self.expiry_priority
                .push(record.name.clone(), Reverse(entry.next_expiry));
            self.entries.insert(record.name.clone(), entry);
        }

        self.current_size += 1;
    }
```

I didn't write this all in one go and get it right the first time.  I
first implemented this *without* the duplicate handling then, when it
was working, I made it prevent duplicate records.

If you allow duplicates, the `if let Some(tuples)` block becomes much
simpler:

```rust
if let Some(tuples) = entry.records.get_mut(&rtype) {
    tuples.push(tuple);
} else {
    entry.records.insert(rtype, vec![tuple]);
}
```

We've made it---the end of the operations!

### Testing

This code is pretty involved, and I've already said that I made at
least one mistake when first writing it.  So how do I know it's
correct?

Tests.

Tests, tests, tests.

I'm not going to go into the actual test code ([see the source if you
want that][]), but I will outline the cases.

[see the source if you want that]: https://github.com/barrucadu/resolved/blob/master/src/resolver/cache.rs

The most important thing is to have a good way to generate inputs: you
want distinct domains, overlapping domains, distinct types,
overlapping types, overlapping but unequal records... the whole
shebang.  I'm generating random records, rather than trying to
enumerate all the useful cases.  I'm a big fan of random inputs in
testing in general.

Some say "oh, but if my test is randomised it'll be flaky: it might
pass some times and fail other times!"  In which case... good?  If
your test fails, you've found a bug: fix it!

Anyway, here are my test cases:

- Insert a record and then check I can retrieve it:
  - With `QueryType::Record(_)` and `QueryClass::Record(_)`
  - With `QueryType::Wildcard` and `QueryClass::Record(_)`
  - With `QueryType::Record(_)` and `QueryClass::Wildcard`
  - With `QueryType::Wildcard` and `QueryClass::Wildcard`
- Insert the same record twice and check the `current_size` only goes
  up by 1, and that the invariants hold.
- Insert 100 random records and check that the invariants hold.
- Insert 100 random records, check that they can all be retrieved, and
  that the invariants hold.
- Insert 100 random records into a cache with a `desired_size` of 25,
  call `prune`, and check that 25 records remain and that the
  invariants hold.
- Insert 100 random records, 49 of which have a TTL of 0, call
  `remove_expired`, and check that 51 remain and that the invariants
  hold.
- Insert 100 random records into a cache with a `desired_size` of 99,
  49 of which have a TTL of 0, call `prune`, and check that 51 remain
  and that the invariants hold.

In most of those tests I check that the data structure invariants
hold, there I:

- Check that the `current_size` is equal to the total number of
  records.
- Check that the `entries` and the `access_priority` are the same
  size.
- Check that the `entries` and the `expiry_priority` are the same
  size.
- Check the `next_expiry` for each domain is equal to the minimum of
  its records' expiry times.
- Build a new `access_priority` from the domains and check it's the
  same as the stored one.
- Build a new `expiry_priority` from the domains and check it's the
  same as the stored one.

I feel pretty confident that my tests cover a variety of different
cases and sequences of operations, and that I would have found any
significant bugs.  There could always be subtle bugs lurking, but
that's true of all code.

### Periodic pruning

I've opted to prune the cache in two places.

Firstly, in my actual code, this cache is inside an `Arc<Mutex<_>>`,
so it can be shared across threads.  There's not much point in having
an unshared cache, after all.  Anyway, this wrapper has some helper
methods to get and insert entries, and the get helper calls
`remove_expired` if it fetches any expired records:

```rust
impl SharedCache {
    pub fn get(
        &self,
        name: &DomainName,
        qtype: &QueryType,
        qclass: &QueryClass,
    ) -> Vec<ResourceRecord> {
        let mut rrs = self.get_without_checking_expiration(name, qtype, qclass);
        let len = rrs.len();
        rrs.retain(|rr| rr.ttl > Duration::ZERO);
        if rrs.len() != len {
            self.remove_expired();
        }
        rrs
    }

    // ... more omitted
}
```

Secondly, I spawn a [tokio][] task to periodically remove expired
entries, and then do additional pruning if need be:

[tokio]: https://tokio.rs/

```rust
async fn prune_cache_task(cache: SharedCache) {
    loop {
        sleep(Duration::from_secs(60 * 5)).await;

        let expired = cache.remove_expired();
        let pruned = cache.prune();

        println!(
            "[CACHE] expired {:?} and pruned {:?} entries",
            expired, pruned
        );
    }
}
```

It was very satisfying when I added this and first saw that `[CACHE]`
output with non-zero expired and pruned records.

## What Next?

This cache works, and it works well.  I get nice and fast responses
from my DNS server for queries which are wholly or partially cached,
and [the benchmarks I've written][] look promising:

[the benchmarks I've written]: https://github.com/barrucadu/resolved/blob/master/benches/cache.rs

```
insert/unique/1         time:   [1.0965 us 1.1001 us 1.1044 us]
                        thrpt:  [905.51 Kelem/s 909.00 Kelem/s 912.01 Kelem/s]
insert/unique/100       time:   [115.72 us 115.96 us 116.24 us]
                        thrpt:  [860.27 Kelem/s 862.39 Kelem/s 864.15 Kelem/s]
insert/unique/1000      time:   [1.1769 ms 1.1787 ms 1.1807 ms]
                        thrpt:  [846.96 Kelem/s 848.36 Kelem/s 849.67 Kelem/s]

insert/duplicate/1      time:   [1.1927 us 1.1964 us 1.2003 us]
                        thrpt:  [833.13 Kelem/s 835.86 Kelem/s 838.44 Kelem/s]
insert/duplicate/100    time:   [56.880 us 57.047 us 57.221 us]
                        thrpt:  [1.7476 Melem/s 1.7529 Melem/s 1.7581 Melem/s]
insert/duplicate/1000   time:   [541.33 us 542.10 us 542.93 us]
                        thrpt:  [1.8419 Melem/s 1.8447 Melem/s 1.8473 Melem/s]

get_without_checking_expiration/hit/1
                        time:   [1.4057 us 1.4249 us 1.4425 us]
                        thrpt:  [693.22 Kelem/s 701.81 Kelem/s 711.40 Kelem/s]
get_without_checking_expiration/hit/100
                        time:   [84.651 us 84.999 us 85.322 us]
                        thrpt:  [1.1720 Melem/s 1.1765 Melem/s 1.1813 Melem/s]
get_without_checking_expiration/hit/1000
                        time:   [991.64 us 997.89 us 1.0030 ms]
                        thrpt:  [996.98 Kelem/s 1.0021 Melem/s 1.0084 Melem/s]

get_without_checking_expiration/miss/1
                        time:   [948.17 ns 961.92 ns 974.39 ns]
                        thrpt:  [1.0263 Melem/s 1.0396 Melem/s 1.0547 Melem/s]
get_without_checking_expiration/miss/100
                        time:   [45.399 us 46.116 us 46.671 us]
                        thrpt:  [2.1426 Melem/s 2.1684 Melem/s 2.2027 Melem/s]
get_without_checking_expiration/miss/1000
                        time:   [570.42 us 577.92 us 583.75 us]
                        thrpt:  [1.7131 Melem/s 1.7303 Melem/s 1.7531 Melem/s]

remove_expired/1        time:   [1.2796 us 1.2983 us 1.3151 us]
                        thrpt:  [760.38 Kelem/s 770.26 Kelem/s 781.52 Kelem/s]
remove_expired/100      time:   [55.622 us 56.761 us 57.895 us]
                        thrpt:  [1.7273 Melem/s 1.7618 Melem/s 1.7978 Melem/s]
remove_expired/1000     time:   [786.47 us 794.30 us 800.89 us]
                        thrpt:  [1.2486 Melem/s 1.2590 Melem/s 1.2715 Melem/s]

prune/1                 time:   [1.3455 us 1.3539 us 1.3617 us]
                        thrpt:  [734.36 Kelem/s 738.63 Kelem/s 743.24 Kelem/s]
prune/100               time:   [41.584 us 41.676 us 41.774 us]
                        thrpt:  [2.3938 Melem/s 2.3995 Melem/s 2.4048 Melem/s]
prune/1000              time:   [613.73 us 617.63 us 620.87 us]
                        thrpt:  [1.6106 Melem/s 1.6191 Melem/s 1.6294 Melem/s]
```

But could it be better?

The only optimisation that really comes to mind is using a trie
instead of the `HashMap` for domains.  Another possibility is turning
it into a more generic size-bounded-LRU-cache-with-expiration data
structure with type parameters, and so making the DNS usage just a
specialisation of that; perhaps genericising the code would make it
easier to see improvements.

But nothing *needs* to be done, it works pretty well as it is.  When I
start using my DNS server for my LAN, and it starts to get much more
traffic than my test instance, I'm sure performance problems will
start to crop up, but hopefully they won't be with this cache.
