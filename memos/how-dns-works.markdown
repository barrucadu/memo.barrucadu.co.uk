---
title: How DNS works
taxon: general
published: 2022-04-03
---

The Domain Name System is a huge distributed eventually-consistent
database[^nosql] mapping names, like `memo.barrucadu.co.uk`, to
numbers, like `116.203.34.201`.  It's federated, with trusted entities
(you may have heard of the "DNS root servers") delegating control of
segments of the DNS namespace to others.  It holds hundreds of
millions of records, and updates to this database are typically
visible in minutes to hours.

[^nosql]: You could even call it a "NoSQL" database, if you really
    must.

And the protocol behind it is not massively different to when it was
standardised in the 1980s.

In this memo I'll cover:

1. The DNS protocol
2. How your browser gets from `memo.barrucadu.co.uk` to an IP address
3. What a "zone" is
4. The difference between authoritative, recursive, and forwarding nameservers
5. What happens when you update a DNS record (there's no such thing as "propagation")
6. Finally, whether these old standards I'm talking about are still enough, today

If you want to get it straight from the horse's mouth, [RFC 1034:
Domain Names - Concepts and Facilities][RFC 1034] and [RFC 1035: Domain
Names - Implementation and Specification][RFC 1035] are the standards I'm
drawing on.  They're very approachable, and I encourage you to read
them.

You can also look at [resolved][], the DNS server I wrote, which acts
as both a recursive (or forwarding) and authoritative nameserver, and
is suitable for home networks.  Well, my home network.  I can't
promise anything about yours.


## The DNS protocol

Let's start with an example:[^noedns]

[^noedns]: The `+noedns` flag turns off some extensions to the basic
    DNS protocol, which I'm not covering for simplicity.

```
$ dig memo.barrucadu.co.uk +noedns
; <<>> DiG 9.16.25 <<>> memo.barrucadu.co.uk +noedns
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37169
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 4, ADDITIONAL: 0

;; QUESTION SECTION:
;memo.barrucadu.co.uk.          IN      A

;; ANSWER SECTION:
memo.barrucadu.co.uk.   292     IN      CNAME   barrucadu.co.uk.
barrucadu.co.uk.        292     IN      A       116.203.34.201

;; AUTHORITY SECTION:
barrucadu.co.uk.        2975    IN      NS      ns-98.awsdns-12.com.
barrucadu.co.uk.        2975    IN      NS      ns-1520.awsdns-62.org.
barrucadu.co.uk.        2975    IN      NS      ns-1828.awsdns-36.co.uk.
barrucadu.co.uk.        2975    IN      NS      ns-763.awsdns-31.net.

;; Query time: 0 msec
;; SERVER: 185.12.64.2#53(185.12.64.2)
;; WHEN: Tue Mar 22 16:42:02 GMT 2022
;; MSG SIZE  rcvd: 202
```

I've used `dig` a lot so I'm fairly used to reading this output, but
I've since realised I wasn't *really* reading it.

What does `flags: qr rd ra` mean?

The `QUESTION SECTION` and `ANSWER SECTION` make sense, but what's the
point of the `AUTHORITY SECTION`?  Do *all* queries have an `AUTHORITY
SECTION`?

```
$ dig www.google.com +noedns
; <<>> DiG 9.16.25 <<>> www.google.com +noedns
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 46676
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;www.google.com.                        IN      A

;; ANSWER SECTION:
www.google.com.         102     IN      A       142.250.185.100

;; Query time: 0 msec
;; SERVER: 185.12.64.2#53(185.12.64.2)
;; WHEN: Tue Mar 22 16:49:36 GMT 2022
;; MSG SIZE  rcvd: 48
```

...no `AUTHORITY SECTION` there.  Is it unimportant?  Or optional?

Also, all the domain names there have a trailing dot.  What's that
about?[^trailing_dot]

[^trailing_dot]: Ok, I've actually known this one for a while, because
  I'm the sort of person to pedantically bring that up.

Time to dig into the protocol.  [RFC 1035][] is our guide here.

### Format of a DNS Message

DNS has two types of messages, queries and responses, and uses port
53.  It prefers UDP but, if a message is too long to send in a single
UDP datagram, it falls back to TCP.

A DNS message has five parts.  These are:

1. A header, which specifies what sort of message this is and how many
   entries are in the other parts. This also has those flags we saw in
   the `dig` output.

2. The "question section", which specifies what sort of records the
   client is interested in.  Did you know that you can ask multiple
   questions with a single DNS query?  I didn't.

3. The "answer section", a collection of records directly answering
   the questions.

4. The "authority section", a series of `NS` records pointing to an
   authoritative source which can answer the questions.

5. The "additional section", a series of records which may be useful
   when using records from the answer and authority sections.  For
   example, the `A` records for any nameservers given in the authority
   section.

The answer, authority, and additional sections won't be present in a
query.  But the question section *will* be present in a response: it's
copied over from the query.

### The Header

The header is 12 bytes long and has a few different fields packed in
there.  [RFC 1035][] has some nice ASCII art illustrations:

```asciiart
                                    1  1  1  1  1  1
      0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                      ID                       |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    QDCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ANCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    NSCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    ARCOUNT                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
```

Where,

- `ID` is a 16-bit random identifier set by the client and copied into
  the response by the server.  Since UDP is connectionless, this is
  essential for the client to know which response goes with which
  query.[^sp]

- `QR` indicates whether this is a query (0) or a response (1).

- `OPCODE` is a four-bit field, set by the client and copied into the
  response by the server, indicating what type of query this message
  is.  The most common opcode is 0, which is a "standard query".

- `AA` ("Authoritative Answer") is set by the server and means that
  this response is *authoritative*.

  More on authority in [zones?](how-dns-works.html#zones)

- `TC` ("Truncation") is set by the server and means that the full
  response couldn't fit in a single UDP datagram, and so the client
  should try again using TCP.[^alpine_tc]

- `RD` ("Recursion Desired") is set by the client, and copied into the
  response by the server, and means that they would like the server to
  answer the question recursively, if they can.

  More on recursive and non-recursive resolution in [how resolution
  happens](how-dns-works.html#how-resolution-happens).

- `RA` ("Recursion Available") is set by the server and means that it
  can perform recursive resolution, if requested.

- `Z` is reserved for future use, and so should be set to zero if you
  don't implement those future standards.

- `RCODE` is a four-bit field, set by the server, indicating what type
  of response this message is.  There are a few common ones:

  - 0 means no error
  - 1 means the server couldn't understand the query
  - 2 means the server encountered an error processing the query
  - 3 means the domain name in the query doesn't exist
  - 4 means the server doesn't support this sort of query
  - 5 means the server refused to answer the query

- `QDCOUNT`, `ANCOUNT`, `NSCOUNT`, and `ARCOUNT` are unsigned 16-bit
  (big endian) integers specifying the number of entries in the
  question, answer, authority, and additional sections (respectively)
  of the message.

[^sp]: Well, this plus source port matching.  There are also some
    other security mechanisms DNS clients sometimes use to prevent
    spoofed responses, like randomly capitalising letters in the
    question names (since DNS is case-insensitive), and checking that
    the response from the server uses the same random capitalisation.

[^alpine_tc]: Fun fact, Alpine Linux doesn't support DNS over TCP, so
  it can break [if a truncated response doesn't include enough
  complete records for it to make
  progress](https://christoph.luppri.ch/fixing-dns-resolution-for-ruby-on-alpine-linux).

Since all the multi-byte fields in a DNS message are unsigned and big
endian, I'll not mention it from now on.

### Domain Names

Before diving into the other sections, let's have a look at how domain
names are encoded.  They show up a lot, after all.

Let's take the domain name `memo.barrucadu.co.uk.`, and separate it by
dots.  This gives us a sequence of *labels*:

1. `memo`
2. `barrucadu`
3. `co`
4. `uk`
5. (the empty label)

How you actually interpret those labels is a bit confused,
unfortunately.

[RFC 1035][] says that they are sequences of arbitrary octets and that
you can't assume any particular character encoding... but it *also*
says that labels are to be compared case-insensitively.

[RFC 4343][] clarifies that that means octets in the range `0x41` to
`0x5a` (the upper case ASCII letters) are considered equal to
corresponding octets in the range `0x61` to `0x7a` (the lower case
ASCII letters), and vice versa, but that that *still* doesn't mean
that labels are ASCII, as they can also contain arbitrary non-ASCII
octets.

But there's also [RFC 3492][], which defines the punycode standard for
encoding internationalised, *i.e.* unicode, domain names into ASCII.
So maybe domain names *are* ASCII after all?

There may well be a later RFC which resolves this ambiguity and says
that labels are definitely ASCII, but I haven't seen it yet.

Anyway, back to the topic of encoding.

A label is encoded as a one-octet length field followed by the octets
of the label.  And an encoded domain name is a sequence of encoded
labels.  This means that a domain name ends with `0x00`, the length of
the empty label.[^nullstr]

[^nullstr]: And also makes encoded domain names work as
  null-terminated strings in C in the (very common) case where none of
  the labels contain a null byte.  What a fortuitous coincidence!

So `memo.barrucadu.co.uk` is encoded as:

```
0x04 m e m o 0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00
```

There are two restrictions on the validity of domain names:

- A single label may be no more than 63 octets long (not including the
  length octet)

- An entire encoded domain name may be no more than 255 octets long
  (including the label length octets)

#### Compression

Unfortunately, that's not all.

Domain names get repeated a lot in DNS messages, and the 512 bytes of
a UDP datagram can start to feel pretty limiting.  So DNS also has a
compression mechanism, where some suffix of a domain name can be
replaced with a pointer to an earlier occurrence of that name.

So if the name `memo.barrucadu.co.uk.` appears in a message twice, the
second occurrence could be represented as:

- `memo.barrucadu.co.uk.`
- `memo.barrucadu.co.[pointer to uk.]`
- `memo.barrucadu.[pointer to co.uk.]`
- `memo.[pointer to barrucadu.co.uk.]`
- `[pointer to memo.barrucadu.co.uk.]`

But how do you distinguish between a regular label and a pointer?
Well, remember that a label can't be longer than 63 octets.  And
what's 63 as an 8-bit binary number?

It's `00111111`.

There's two whole bits there at the front which are completely wasted!

So pointers are encoded as the two-octet sequence `11[14-bit index
into message]`.

Pretty clever.

### Questions

```asciiart
                                    1  1  1  1  1  1
      0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                                               |
    /                     QNAME                     /
    /                                               /
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                     QTYPE                     |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                     QCLASS                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
```

Where,

- `QNAME` is the domain name, which can be any length (so long as it's
  properly encoded), it's not padded to any specific size.

- `QTYPE` is a 16-bit integer specifying the type of records the
  client is interested in.  Which will usually be a record type (see
  the next subsection) or 255, meaning "all records".  There are a few
  other `QTYPE`s but those are less common.

- `QCLASS` is a 16-bit integer specifying which *network class* the
  client is interested in.  These days this will always be 1, or `IN`,
  for "internet".[^waste]

[^waste]: It feels kind of wasteful that we effectively throw away 16
  whole bits for each question and record on this historical artefact.
  UDP messages are short, so we compress domain names to squeeze out a
  little extra space, but then we waste a bunch like this!  Even
  worse, there never were very many network classes: [RFC 1035][] only
  defines *four*.  Did the IETF really expect there to be so many
  non-internet networks in the future?

We can now understand the question section of our `dig` example!

```
;; QUESTION SECTION:
;memo.barrucadu.co.uk.          IN      A
```

Means that it's looking for an internet address record for
`memo.barrucadu.co.uk.` (yes, it shows the type and class the other
way around).  That question is encoded as:

```
0x04 m e m o 0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00  ; qname:  memo.barrucadu.co.uk.
0x00 0x01                                                   ; qtype:  A
0x00 0x01                                                   ; qclass: IN
```

### Resource Records

The answer, authority, and additional sections are all a sequence of
*resource records*:

```asciiart
                                    1  1  1  1  1  1
      0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                                               |
    /                                               /
    /                      NAME                     /
    |                                               |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                      TYPE                     |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                     CLASS                     |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                      TTL                      |
    |                                               |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                   RDLENGTH                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
    /                     RDATA                     /
    /                                               /
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
```

Where,

- `NAME` is the domain name, which is variable-length like the `QNAME`
  of a question.

- `TYPE` is a 16-bit integer specifying what sort of record this is.
  There are a fair few of these, but some common ones are:

  - 1, an `A` record
  - 2, a `NS` record
  - 5, a `CNAME` record
  - 28, a `AAAA` record (from [RFC 3596][])
  - and plenty others

- `CLASS` is a 16-bit integer specifying what network class this
  record applies to.  Like the `QCLASS`, these days this will always
  be 1.  Unless you're specifically running some sort of old
  non-IP-based network for fun.

- `TTL` is a 32-bit integer specifying the number of seconds that this
  record is valid for.  This is important for caching purposes.  Zero
  has a special meaning: it means that you can use the record to do
  whatever it is you're doing *right now*, but that you can't cache it
  at all.

- `RDLENGTH` is a 16-bit integer specifying the length of the `RDATA`
  section.

- `RDATA` is the record data, which is type- and class-specific.  For
  example:

  - `IN A` records hold an IPv4 address, as a 32-bit number
  - `IN NS` and `IN CNAME` records hold a domain name
  - `IN AAAA` records hold an IPv6 address, as a 128-bit number

Returning to our `dig` example, we had a few different resource
records in the response.  Let's just look at the answer section:

```
;; ANSWER SECTION:
memo.barrucadu.co.uk.   292     IN      CNAME   barrucadu.co.uk.
barrucadu.co.uk.        292     IN      A       116.203.34.201
```

We have one `IN CNAME` record for `memo.barrucadu.co.uk.` and one `IN
A` record for `barrucadu.co.uk.`.  This is because, upon encountering
a `CNAME`, resolution starts again with whatever name the `CNAME`
refers to.[^cname]

[^cname]: Unless the query was for, say, `IN CNAME
    memo.barrucadu.co.uk.`.  More on this in [how resolution
    happens](how-dns-works.html#how-resolution-happens).

Leaving out the name compression for simplicity, those records are
encoded as:

```
0x04 m e m o 0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00  ; name:     memo.barrucadu.co.uk.
0x00 0x05                                                   ; type:     CNAME
0x00 0x01                                                   ; class:    IN
0x00 0x00 0x01 0x24                                         ; ttl:      292
0x00 0x11                                                   ; rdlength: 17
0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00               ; rdata:    barrucadu.co.uk.

0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00               ; name:     barrucadu.co.uk.
0x00 0x01                                                   ; type:     A
0x00 0x01                                                   ; class:    IN
0x00 0x00 0x01 0x24                                         ; ttl:      292
0x00 0x04                                                   ; rdlength: 4
0x74 0xcb 0x22 0xc9                                         ; rdata:    116.203.34.201
```

### Example DNS query & response

Returning to our `dig memo.barrucadu.co.uk +noedns` example from the
beginning, we can now see the whole encoded query and response.  I've
included comments and linebreaks to make it clear what's what.

Here's the query:

```
;; header
0xb6 0x54 ; ID: 46676
0x01 0x00 ; flags: RD
0x00 0x01 ; QDCOUNT: 1
0x00 0x00 ; ANCOUNT: 0
0x00 0x00 ; NSCOUNT: 0
0x00 0x00 ; ARCOUNT: 0

;; question section
; memo.barrucadu.co.uk. A IN
0x04 m e m o 0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00 0x00 0x01 0x00 0x01
```

And here's the response (omitting compression):

```
;; header
0xb6 0x54 ; ID: 46676
0x81 0x80 ; flags: QR, RD, RA
0x00 0x01 ; QDCOUNT: 1
0x00 0x02 ; ANCOUNT: 2
0x00 0x04 ; NSCOUNT: 4
0x00 0x00 ; ARCOUNT: 0

;; question section
; memo.barrucadu.co.uk. A IN
0x04 m e m o 0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00 0x00 0x01 0x00 0x01

;; answer section
; memo.barrucadu.co.uk. CNAME IN 292 barrucadu.co.uk.
0x04 m e m o 0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00 0x00 0x05 0x00 0x01 0x00 0x00 0x01 0x24 0x00 0x11 0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00
; barrucadu.co.uk. A IN 292 116.203.34.201
0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00 0x00 0x01 0x00 0x01 0x00 0x00 0x01 0x24 0x00 0x04 0x74 0xcb 0x22 0xc9

;; authority section
; barrucadu.co.uk. NS IN 2975 ns-98.awsdns-12.com.
0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00 0x00 0x02 0x00 0x01 0x00 0x00 0x0b 0x9f 0x00 0x15 0x05 n s - 9 8 0x09 a w s d n s - 1 2 0x03 c o m 0x00
; barrucadu.co.uk. NS IN 2975 ns-1520.awsdns-62.org.
0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00 0x00 0x02 0x00 0x01 0x00 0x00 0x0b 0x9f 0x00 0x17 0x07 n s - 1 5 2 0 0x09 a w s d n s - 6 2 0x03 o r g 0x00
; barrucadu.co.uk. NS IN 2975 ns-1828.awsdns-36.co.uk.
0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00 0x00 0x02 0x00 0x01 0x00 0x00 0x0b 0x9f 0x00 0x19 0x07 n s - 1 8 2 8 0x09 a w s d n s - 3 6 0x02 c o 0x02 u k 0x00
; barrucadu.co.uk. NS IN 2975 ns-763.awsdns-31.net.
0x09 b a r r u c a d u 0x02 c o 0x02 u k 0x00 0x00 0x02 0x00 0x01 0x00 0x00 0x0b 0x9f 0x00 0x16 0x06 n s - 7 6 3 0x09 a w s d n s - 3 1 0x03 n e t 0x00
```

And that's that!

The DNS protocol isn't very complicated.  But it *is* somewhat fiddly,
what with each record type having its own `RDATA` format, and the
domain name compression.  One big thing I learned implementing
[resolved][] is to *always* fuzz test your serialisation and
deserialisation logic.


## How resolution happens

When we ran `dig memo.barrucadu.co.uk +noedns` in the previous
section, we got an answer.  We found the IP address which
`memo.barrucadu.co.uk.` refers to.

But *how?*

Well, `dig` tells us that it talked to some server at 185.12.64.2.
But how did *that* server know?  Does it have a copy of the entire
DNS?  Unlikely, since there are hundreds of millions of records in
use.

The answer is that the server followed a process called *recursive
resolution*.  This is described in section 5.3.3 of [RFC 1034][]:

1. See if we already know the answer (*e.g.* the relevant records are
   already cached), and return it to the client if so
2. Figure out the best nameservers to ask
3. Send them queries until one responds
4. Analyse the response:
   - If the response answers the question, cache it and return it to
     the client
   - If the response gives some better nameservers to use, cache them
     and go back to step 2
   - If the response gives a CNAME, and this is not the answer, cache
     the CNAME record and start again with the new name
   - If the response is an error or doesn't make sense, go back to
     step 3

On the face of it this looks pretty straightforward... but on closer
inspection that step 2 is doing a lot of work: how exactly do we
"figure out the best nameservers to ask"?[^sna]

[^sna]: That step 1 is also doing a surprising amount of work if your
  nameserver supports authoritative zones (see next section).  For the
  full gory details, see section 4.3.2 of [RFC 1034][].

Well, step 4.b gives us a clue here: *if the response gives some
better nameservers to use, cache them and go back to step 2.*  So we
don't need to pick the correct nameservers at the very beginning.  We
only need to know about a nameserver which will be able to point us to
a nameserver which knows that (or is closer to knowing that).

There are thirteen nameservers which, transitively, know about *every*
domain name.  These are the root nameservers, and they're where
recursive resolution starts.

You can find them at `a.root-servers.net.` through
`m.root-servers.net.`

So you just point your recursive resolver at, say,
`j.root-servers.net.`  and... oh wait, we have a chicken-and-egg
problem.  Ultimately, you need to know their IP addresses.  IANA, the
Internet Assigned Numbers Authority, provides the ["root hints"
file][], which has the IPv4 and IPv6 addresses of these root
nameservers.

How do you download that file if you don't have DNS working to resolve
`www.iana.org.`?  Look, you just need IP addresses to get DNS and DNS
to get IP addresses.  Use 1.1.1.1 or something while you get your
fancy recursive resolver working.

Alright, let's resolve `memo.barrucadu.co.uk.` recursively!  Starting
with:

```
$ dig memo.barrucadu.co.uk @j.root-servers.net
; <<>> DiG 9.16.27 <<>> memo.barrucadu.co.uk @j.root-servers.net
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 48477
;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 8, ADDITIONAL: 17
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;memo.barrucadu.co.uk.          IN      A

;; AUTHORITY SECTION:
uk.                     172800  IN      NS      dns1.nic.uk.
uk.                     172800  IN      NS      dns4.nic.uk.
uk.                     172800  IN      NS      nsa.nic.uk.
uk.                     172800  IN      NS      nsd.nic.uk.
uk.                     172800  IN      NS      nsc.nic.uk.
uk.                     172800  IN      NS      nsb.nic.uk.
uk.                     172800  IN      NS      dns3.nic.uk.
uk.                     172800  IN      NS      dns2.nic.uk.

;; ADDITIONAL SECTION:
dns1.nic.uk.            172800  IN      A       213.248.216.1
dns1.nic.uk.            172800  IN      AAAA    2a01:618:400::1
dns4.nic.uk.            172800  IN      A       43.230.48.1
dns4.nic.uk.            172800  IN      AAAA    2401:fd80:404::1
nsa.nic.uk.             172800  IN      A       156.154.100.3
nsa.nic.uk.             172800  IN      AAAA    2001:502:ad09::3
nsd.nic.uk.             172800  IN      A       156.154.103.3
nsd.nic.uk.             172800  IN      AAAA    2610:a1:1010::3
nsc.nic.uk.             172800  IN      A       156.154.102.3
nsc.nic.uk.             172800  IN      AAAA    2610:a1:1009::3
nsb.nic.uk.             172800  IN      A       156.154.101.3
nsb.nic.uk.             172800  IN      AAAA    2001:502:2eda::3
dns3.nic.uk.            172800  IN      A       213.248.220.1
dns3.nic.uk.            172800  IN      AAAA    2a01:618:404::1
dns2.nic.uk.            172800  IN      A       103.49.80.1
dns2.nic.uk.            172800  IN      AAAA    2401:fd80:400::1

;; Query time: 4 msec
;; SERVER: 2001:503:c27::2:30#53(2001:503:c27::2:30)
;; WHEN: Sat Apr 02 23:20:04 BST 2022
;; MSG SIZE  rcvd: 553
```

Alright, we now know the names and IP addresses of the `uk.`
nameservers.  Thanks, additional section!

On we go:

```
$ dig memo.barrucadu.co.uk @213.248.216.1
; <<>> DiG 9.16.27 <<>> memo.barrucadu.co.uk @213.248.216.1
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43056
;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 4, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;memo.barrucadu.co.uk.          IN      A

;; AUTHORITY SECTION:
barrucadu.co.uk.        172800  IN      NS      ns-98.awsdns-12.com.
barrucadu.co.uk.        172800  IN      NS      ns-763.awsdns-31.net.
barrucadu.co.uk.        172800  IN      NS      ns-1520.awsdns-62.org.
barrucadu.co.uk.        172800  IN      NS      ns-1828.awsdns-36.co.uk.

;; Query time: 14 msec
;; SERVER: 213.248.216.1#53(213.248.216.1)
;; WHEN: Sat Apr 02 23:21:28 BST 2022
;; MSG SIZE  rcvd: 183
```

No additional section here, so we'll need to resolve one of those
nameservers.  Back to the root!

```
$ dig ns-98.awsdns-12.com @j.root-servers.net
; <<>> DiG 9.16.27 <<>> ns-98.awsdns-12.com @j.root-servers.net
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 8418
;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 13, ADDITIONAL: 27
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;ns-98.awsdns-12.com.           IN      A

;; AUTHORITY SECTION:
com.                    172800  IN      NS      a.gtld-servers.net.
com.                    172800  IN      NS      b.gtld-servers.net.
com.                    172800  IN      NS      c.gtld-servers.net.
com.                    172800  IN      NS      d.gtld-servers.net.
com.                    172800  IN      NS      e.gtld-servers.net.
com.                    172800  IN      NS      f.gtld-servers.net.
com.                    172800  IN      NS      g.gtld-servers.net.
com.                    172800  IN      NS      h.gtld-servers.net.
com.                    172800  IN      NS      i.gtld-servers.net.
com.                    172800  IN      NS      j.gtld-servers.net.
com.                    172800  IN      NS      k.gtld-servers.net.
com.                    172800  IN      NS      l.gtld-servers.net.
com.                    172800  IN      NS      m.gtld-servers.net.

;; ADDITIONAL SECTION:
a.gtld-servers.net.     172800  IN      A       192.5.6.30
b.gtld-servers.net.     172800  IN      A       192.33.14.30
c.gtld-servers.net.     172800  IN      A       192.26.92.30
d.gtld-servers.net.     172800  IN      A       192.31.80.30
e.gtld-servers.net.     172800  IN      A       192.12.94.30
f.gtld-servers.net.     172800  IN      A       192.35.51.30
g.gtld-servers.net.     172800  IN      A       192.42.93.30
h.gtld-servers.net.     172800  IN      A       192.54.112.30
i.gtld-servers.net.     172800  IN      A       192.43.172.30
j.gtld-servers.net.     172800  IN      A       192.48.79.30
k.gtld-servers.net.     172800  IN      A       192.52.178.30
l.gtld-servers.net.     172800  IN      A       192.41.162.30
m.gtld-servers.net.     172800  IN      A       192.55.83.30
a.gtld-servers.net.     172800  IN      AAAA    2001:503:a83e::2:30
b.gtld-servers.net.     172800  IN      AAAA    2001:503:231d::2:30
c.gtld-servers.net.     172800  IN      AAAA    2001:503:83eb::30
d.gtld-servers.net.     172800  IN      AAAA    2001:500:856e::30
e.gtld-servers.net.     172800  IN      AAAA    2001:502:1ca1::30
f.gtld-servers.net.     172800  IN      AAAA    2001:503:d414::30
g.gtld-servers.net.     172800  IN      AAAA    2001:503:eea3::30
h.gtld-servers.net.     172800  IN      AAAA    2001:502:8cc::30
i.gtld-servers.net.     172800  IN      AAAA    2001:503:39c1::30
j.gtld-servers.net.     172800  IN      AAAA    2001:502:7094::30
k.gtld-servers.net.     172800  IN      AAAA    2001:503:d2d::30
l.gtld-servers.net.     172800  IN      AAAA    2001:500:d937::30
m.gtld-servers.net.     172800  IN      AAAA    2001:501:b1f9::30

;; Query time: 3 msec
;; SERVER: 2001:503:c27::2:30#53(2001:503:c27::2:30)
;; WHEN: Sat Apr 02 23:22:36 BST 2022
;; MSG SIZE  rcvd: 844
```

We've got the `com.` nameservers.  Next![^com]

[^com]: I know it's a necessary consequence of how DNS works, but I
  still find it pretty cool that there are servers which know about
  literally every `com.` (or `uk.`, or `net.`, etc) domain name.

```
$ dig ns-98.awsdns-12.com @192.5.6.30
; <<>> DiG 9.16.27 <<>> ns-98.awsdns-12.com @192.5.6.30
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 59687
;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 4, ADDITIONAL: 9
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;ns-98.awsdns-12.com.           IN      A

;; AUTHORITY SECTION:
awsdns-12.com.          172800  IN      NS      g-ns-13.awsdns-12.com.
awsdns-12.com.          172800  IN      NS      g-ns-588.awsdns-12.com.
awsdns-12.com.          172800  IN      NS      g-ns-1164.awsdns-12.com.
awsdns-12.com.          172800  IN      NS      g-ns-1740.awsdns-12.com.

;; ADDITIONAL SECTION:
g-ns-13.awsdns-12.com.  172800  IN      A       205.251.192.13
g-ns-13.awsdns-12.com.  172800  IN      AAAA    2600:9000:5300:d00::1
g-ns-588.awsdns-12.com. 172800  IN      A       205.251.194.76
g-ns-588.awsdns-12.com. 172800  IN      AAAA    2600:9000:5302:4c00::1
g-ns-1164.awsdns-12.com. 172800 IN      A       205.251.196.140
g-ns-1164.awsdns-12.com. 172800 IN      AAAA    2600:9000:5304:8c00::1
g-ns-1740.awsdns-12.com. 172800 IN      A       205.251.198.204
g-ns-1740.awsdns-12.com. 172800 IN      AAAA    2600:9000:5306:cc00::1

;; Query time: 23 msec
;; SERVER: 192.5.6.30#53(192.5.6.30)
;; WHEN: Sat Apr 02 23:24:01 BST 2022
;; MSG SIZE  rcvd: 317
```

Nearly there... each query gets us a step or two closer.

```
$ dig ns-98.awsdns-12.com @205.251.192.13
; <<>> DiG 9.16.27 <<>> ns-98.awsdns-12.com @205.251.192.13
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43579
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 4, ADDITIONAL: 9
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;ns-98.awsdns-12.com.           IN      A

;; ANSWER SECTION:
ns-98.awsdns-12.com.    172800  IN      A       205.251.192.98

;; AUTHORITY SECTION:
awsdns-12.com.          172800  IN      NS      g-ns-1164.awsdns-12.com.
awsdns-12.com.          172800  IN      NS      g-ns-13.awsdns-12.com.
awsdns-12.com.          172800  IN      NS      g-ns-1740.awsdns-12.com.
awsdns-12.com.          172800  IN      NS      g-ns-588.awsdns-12.com.

;; ADDITIONAL SECTION:
g-ns-1164.awsdns-12.com. 172800 IN      A       205.251.196.140
g-ns-1164.awsdns-12.com. 172800 IN      AAAA    2600:9000:5304:8c00::1
g-ns-13.awsdns-12.com.  172800  IN      A       205.251.192.13
g-ns-13.awsdns-12.com.  172800  IN      AAAA    2600:9000:5300:d00::1
g-ns-1740.awsdns-12.com. 172800 IN      A       205.251.198.204
g-ns-1740.awsdns-12.com. 172800 IN      AAAA    2600:9000:5306:cc00::1
g-ns-588.awsdns-12.com. 172800  IN      A       205.251.194.76
g-ns-588.awsdns-12.com. 172800  IN      AAAA    2600:9000:5302:4c00::1

;; Query time: 13 msec
;; SERVER: 205.251.192.13#53(205.251.192.13)
;; WHEN: Sat Apr 02 23:24:41 BST 2022
;; MSG SIZE  rcvd: 333
```

We've got an IP address for `ns-98.awsdns-12.com.`!  Now we can answer
our original question:

```
$ dig memo.barrucadu.co.uk @205.251.192.98
; <<>> DiG 9.16.27 <<>> memo.barrucadu.co.uk @205.251.192.98
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26684
;; flags: qr aa rd; QUERY: 1, ANSWER: 2, AUTHORITY: 4, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;memo.barrucadu.co.uk.          IN      A

;; ANSWER SECTION:
memo.barrucadu.co.uk.   300     IN      CNAME   barrucadu.co.uk.
barrucadu.co.uk.        300     IN      A       116.203.34.201

;; AUTHORITY SECTION:
barrucadu.co.uk.        172800  IN      NS      ns-1520.awsdns-62.org.
barrucadu.co.uk.        172800  IN      NS      ns-1828.awsdns-36.co.uk.
barrucadu.co.uk.        172800  IN      NS      ns-763.awsdns-31.net.
barrucadu.co.uk.        172800  IN      NS      ns-98.awsdns-12.com.

;; Query time: 13 msec
;; SERVER: 205.251.192.98#53(205.251.192.98)
;; WHEN: Sat Apr 02 23:25:37 BST 2022
;; MSG SIZE  rcvd: 213
```

And we're done, after 6 requests to other nameservers.  And in a real
nameserver implementation, we'd be checking before each of those
requests whether we already had the answer cached, so likely some of
them (eg, the request to find the `com.` nameservers) wouldn't have
been needed.

["root hints" file]: https://www.iana.org/domains/root/files


## Zones?

In the previous section, it looked very much like the DNS was broken
up into subtrees (or "zones", if you will) based on the label
structure:

- The `.` nameservers knew about the `com.` and `uk.` nameservers, but
  couldn't answer queries about subdomains of those directly
- Similarly, the `uk.` nameservers knew about the nameservers for
  `barrucadu.co.uk.`, but not any of its other records
- And likewise for the `com.` nameservers and `awsdns-12.com.`

This makes sense.  Imagine if the root nameservers knew every DNS
record!  Their databases would be *huge!*  It would be infeasible to
run a handful of servers which know hundreds of millions of records
and which the whole world uses.

So `.` is a zone.  And `uk.` is a zone.  And `barrucadu.co.uk.` is a
zone.  All of the TLDs are zones, and every domain you can buy creates
a new zone.  A zone can be bigger than a single label, *e.g.*
`foo.bar.baz.barrucadu.co.uk.` is in the `barrucadu.co.uk.` zone
unless I *delegate* it to someone else, by creating some `NS` records
for, say, `baz.barrucadu.co.uk.`

That's exactly how registering a domain name works, by the way.  The
registrars have privileged access to the TLD nameservers, and you pay
them some money for them to send a message to the nameservers saying
"please delegate `barrucadu` to these other nameservers".

Zones are traditionally represented in a textual format defined in
[RFC 1035][].[^fiddly] You've seen this format before: it's the format
`dig` gives its responses in and it's the format of the root hints
file (and the root zone file, also provided by IANA).

[^fiddly]: Like the DNS protocol, this format appears to be
  straightforward but is annoyingly fiddly when you come to implement
  it.  It's almost (but not quite!) line-oriented, just about every
  field is optional, and there are two fields which can be written in
  either order.  Just why?

Here's the zone file I use for my LAN DNS:

```
$ORIGIN lan.

@ 300 IN SOA @ @ 4 300 300 300 300

router         300 IN A     10.0.0.1

nyarlathotep   300 IN A     10.0.0.3
*.nyarlathotep 300 IN CNAME nyarlathotep

help           300 IN CNAME nyarlathotep
*.help         300 IN CNAME help

nas            300 IN CNAME nyarlathotep
```

It's a list of records, but note that they all use relative domain
names (no dot at the end).  I could write them as absolute domain
names, but that would be repetitive, and who doesn't want to golf
their zone files?  The `$ORIGIN` line at the top is used to complete
any relative names, and the `@` is an alias for the origin, so this
zone file could also be written as:

```
lan. 300 IN SOA lan. lan. 4 300 300 300 300

router.lan.         300 IN A     10.0.0.1

nyarlathotep.lan.   300 IN A     10.0.0.3
*.nyarlathotep.lan. 300 IN CNAME nyarlathotep.lan.

help.lan.           300 IN CNAME nyarlathotep.lan.
*.help.lan.         300 IN CNAME help.lan.

nas.lan.            300 IN CNAME nyarlathotep.lan.
```

Zones come in two types: *authoritative* (also just called a zone, or
a master zone) and *non-authoritative* (also called hints).  An
authoritative zone has a SOA record, and causes the nameserver to give
authoritative responses to questions which fall into that zone.[^ton]

[^ton]: See the next section for more on authoritative nameservers.

Non-authoritative zones don't, and are primarily useful as a sort of
permanent cache.  Take the root hints file for example: all recursive
resolvers need to know the `NS` records for `.`.  But they should
*not* act as if they're authoritative for `.`, they just know a little
bit about it.

Since any nameserver could claim to be authoritative for any zone it
wants, and I'm sure malicious nameservers often do try to claim
ownership of big sites like `google.com.`, how does the DNS work?

It works on trust.

You trust that the root nameservers will give you the correct
nameservers for all the TLDs.  You then, in turn, trust that the TLD
nameservers will give the correct nameservers for the domains
registered under those TLDs.  And so on, all the way down to the
domain you actually want to resolve.

Not every nameserver operator will be equally trustworthy or
competent, so that trust does erode somewhat as you move further and
further away from the root, but if you do some basic validation of DNS
responses (*e.g.* rejecting a response with NS records for a domain
which is not a subdomain of the zone which you know this nameserver to
be authoritative for), you can do pretty well.


## Types of nameserver

There are, broadly speaking, three sorts of nameservers you see:

- *Authoritative nameservers* are the source of truth for records
  about a given zone.  Typically, these refuse to answer questions for
  other zones.  These set the `AA` flag for queries falling into their
  zones and return a "name error" response if a name they are
  authoritative for doesn't exist.[^nxdomain]

  In [resolved][] this is implemented by the [`dns_resolver::nonrecursive` module][].

- *Recursive nameservers* (or *recursive resolvers*) perform recursive
  resolution for anyone who wants it.  For example: 1.1.1.1, 8.8.8.8,
  and the nameserver your ISP operates.  Typically, these are not
  authoritative for any zones.  Recursive nameservers are convenient
  because the client doesn't need to implement the recursive algorithm
  themselves: they can just fire off a query and get the
  response.[^stub]

  In [resolved][] this is implemented by the [`dns_resolver::recursive` module][].

- *Forwarding nameservers* (or *forwarding resolvers*) forward all
  queries to a recursive resolver, rather than do the recursive
  resolution themselves.  Typically, these are not authoritative for
  any zones.  Forwarding nameservers are simpler than recursive
  nameservers, and they're useful for the same reason any other sort
  of proxy is: they can increase cache hit rate (by having many
  clients go through the forwarding resolver), and selectively falsify
  or block records.[^pihole]

  In [resolved][] this is implemented by the [`dns_resolver::forwarding` module][].

[^nxdomain]: Note that there's a difference between a domain not
  existing and a domain existing but having no records at all (or just
  no records matching the current query).  An authoritative nameserver
  should only return a name error if it *actually* doesn't exist.

[^stub]: In fact, the resolver your operating system uses is probably
  what's called a "stub resolver", rather than a recursive resolver.
  Try configuring your DNS resolver in `/etc/resolv.conf` to be one of
  the root nameservers, rather than a recursive resolver: it won't
  work.

[^pihole]: The [Pi-hole][] is a forwarding resolver which blocks
  advertising domains by returning a fake `A` record pointing to some
  unusable IP address, like 0.0.0.0.

Of course, there's no reason a single nameserver can't do all of those
things at the same time!

Consider bind, *the* big-name nameserver.  Check out its
[configuration documentation][]: it says *any* zone can authoritative,
forwarded, or hints, and the `allow-recursion` option configures
whether recursive queries for zones the server doesn't know about are
allowed.

My [resolved][] server by default supports authoritative zones and
recursive resolution.  It may not appear to support bind-style
zone-specific forwarding, but you could implement that with a hints
file containing NS records for the zone you want to forward, and there
is a command-line flag to forward *all* recursive queries to some
other server.

The reason you'd want to make a nameserver do only one sort of
resolution is to make operation simpler.  In particular, it's good
practice for internet-facing authoritative nameservers to *only*
perform non-recursive resolution.  Answering or rejecting queries
based only on local data makes them have much more predictable
performance.

[`dns_resolver::recursive` module]: https://github.com/barrucadu/resolved/blob/master/lib-dns-resolver/src/recursive.rs
[`dns_resolver::nonrecursive` module]: https://github.com/barrucadu/resolved/blob/master/lib-dns-resolver/src/nonrecursive.rs
[`dns_resolver::forwarding` module]: https://github.com/barrucadu/resolved/blob/master/lib-dns-resolver/src/forwarding.rs
[Pi-hole]: https://pi-hole.net/
[configuration documentation]: https://www-uxsup.csx.cam.ac.uk/pub/doc/redhat/redhat7.3/rhl-rg-en-7.3/s1-bind-configuration.html


## DNS doesn't "propagate"

When I first got into all this web development stuff, the common
wisdom was that DNS changes took 24 to 48 hours to propagate.  But
having seen some details of the DNS protocol and how recursive
resolution works, does that really make sense?  Shouldn't changes be
visible as soon as the TTL of the old record expires?  And shouldn't
new records be visible immediately?  Why do changes need to propagate?
Where do they propagate to?

Propagation implies a push model, where you make your changes and then
they get sent to the resolvers which need them.  But that's not what
happens at all: instead, caches expire.

Ok, there *are* two cases in which DNS does propagate:

1. If you update your domain's NS records, your registrar needs to
   push those changes to the TLD nameservers.  Apparently this used to
   be kind of slow, like, 20+ years ago.  These days it's very fast.
2. If you run a very high traffic authoritative nameserver, you'll
   operate multiple instances of it around the world to improve
   reliability and latency.  So if you change a record, that change
   needs to be pushed out to all your servers.  But this should take
   under a minute unless something is very wrong.

My hunch is that this 24 to 48 hour window came from:

- Registrars being slow to update the TLD nameservers once upon a time
- ISPs running notoriously poorly-behaving nameservers

Ah, ISP DNS.  Almost the first thing any self-respecting nerd changes
when setting up a new home network.  They often do nefarious things
like redirect misspelled domain names to ad-covered search pages,
trying to profit off your typos.  And, as it turns out, a lot of them
ignore record TTLs, and will cache something for a long period if they
feel like it.

How long?  Well, I've seen reports of 24 hours...

Well, no matter what the cause of the occasional slow DNS update
is---though I can't say I've experienced slow DNS updates in a very
long time, and updates are evidently fast enough for changing an A
record to be considered a viable failover mechanism for big
sites---"propagation" is the wrong mental model.

DNS is pull, not push.


## Are RFCs 1034 and 1035 enough?

I've been running [resolved][] for my LAN for about two and a half
weeks now.  And it's working pretty well!  Ok, I have implemented a
few more RFCs:

- [RFC 2782][], which defines the SRV record type, because Minecraft
  can use SRV records to detect the correct port number of a server
  (but that's totally optional, you can also just type in the port in
  the game client).
- [RFC 3596][], which defines the AAAA[^aaaa] type, because I wanted
  to be able to read the official, and unchanged, root hints file.
  But I don't have IPv6 at home so I could make do without this.
- [RFC 6761][], which defines some zones with special behaviour, which
  I distribute as zone files.  This was actually the motivation for me
  to implement authoritative zones, previously I was only going to
  support hints and [Pi-hole][]-like ad-blocking through hosts files.

[^aaaa]: I used to read this as "A-A-A-A" but, having now typed and
  said it a bunch, I've switched to the less tounge-twistery "quad-A".
  I wonder what actual networking people say.

So there are a few things.  But what I've covered in this memo is,
more or less, enough to implement a working nameserver.  You'd need to
look up the formats of a few more common record types in [RFC 1035][],
and also the full algorithm for non-recursive resolution in [RFC
1034][] (which I glossed over in a single sentence), but the point is
that DNS is not very complicated, even today.

There have been new record types; there have been security extensions;
there have been clarifications; some zones have been given special
meaning.  But all of that is optional.

Certainly for a home network, RFCs 1034 and 1035 are enough.

[RFC 1034]: https://datatracker.ietf.org/doc/html/rfc1034
[RFC 1035]: https://datatracker.ietf.org/doc/html/rfc1035
[RFC 2782]: https://datatracker.ietf.org/doc/html/rfc2782
[RFC 3492]: https://datatracker.ietf.org/doc/html/rfc3492
[RFC 3596]: https://datatracker.ietf.org/doc/html/rfc3596
[RFC 4343]: https://datatracker.ietf.org/doc/html/rfc4343
[RFC 6761]: https://datatracker.ietf.org/doc/html/rfc6761
[resolved]: https://github.com/barrucadu/resolved
