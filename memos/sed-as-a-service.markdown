---
title: Sed as a Service
tags: humour, tech
date: 2019-03-10
---

Matching regular expressions can be computationally intensive.  In
fact, [matching regular expressions with backreferences is NP-Hard][].
To make matters worse, while your computer is doing a CPU-bound
task---unlike, say, an IO-bound task---it's not able to do other
things.

I'm sure we're all tired of waiting for complex `sed` invocations in
shell scripts to terminate, using up all of the machine's resources
and preventing other programs from making progress, so I present to
you the solution: `sed`-as-a-service.

By offloading your `sed` invocations to the cloud, you transform a
CPU-bound task to an IO-bound task, so the `sed`-using script can be
suspended, allowing others to run while it waits.

[matching regular expressions with backreferences is NP-Hard]: https://perl.plover.com/NPC/

## Pricing

`sed`-as-a-service pricing is based on the number of lines of data you
query and the size of the regular expressions you use:

- 0.03p per line of stdin, plus
- 50p per half-KiB of argv, capped at 12MiB per calendar
  fortnight[^cf].

[^cf]: The first calendar fortnight of the year begins on the first
  Monday of January.  The final calendar fortnight of the year ends on
  the Sunday immediately prior to the first Monday of January, and may
  in some cases only be a week long.

The current `sed`-as-a-service offering does *not* integrate with
[/dev/null as a service][], but with enough customer demand we may
re-evaluate this decision.

[/dev/null as a service]: https://devnull-as-a-service.com

## API

The `sed`-as-a-service API is very straightforward.  Simply send an
XML payload as the body of a POST request to your HTTP endpoint.  The
payload looks like this:

```xml
<request>
  <stdin>line 1</stdin>
  <stdin>line 2</stdin>
  <stdin>...</stdin>

  <argument>arg 1</argument>
  <argument>arg 2</argument>
  <argument>...</argument>
</request>
```

Any number of lines of input and any number of arguments can be specified.

For example, sending this payload to `http://example.com/sed`:

```xml
<request>
  <argument>s/hello/goodbye/</argument>
  <stdin>hello</stdin>
  <stdin>hello, world</stdin>
</request>
```

Gives the response:

```
goodbye
goodbye, world
```

### Additional UNIX utilities

You can register additional UNIX utilities by sending a PUT request.
For example, you can create a "`grep`-as-a-service" like so:

```bash
curl -XPUT http://example.com/grep
```

To see it in action, send a POST request with a body like this:

```xml
<request>
  <stdin>some</stdin>
  <stdin>words</stdin>
  <stdin>have</stdin>
  <stdin>the</stdin>
  <stdin>letter</stdin>
  <stdin>a</stdin>
  <stdin>in</stdin>
  <stdin>them</stdin>
  <stdin>and</stdin>
  <stdin>some</stdin>
  <stdin>do</stdin>
  <stdin>not</stdin>
  <argument>-v</argument>
  <argument>a</argument>
</request>
```

Which gives the response:

```
some
words
the
letter
in
them
some
do
not
```

## Technical details

When designing the `sed`-as-a-service offering, we considered all
established cloud ecosystems.  For this sort of task, performance is
paramount.  So Java was the obvious choice.

A common concern about startups such as this one is whether the
product will last.  To assist with maintainability and longevity we
follow established Java design patterns wherever conceivable.

For example, we facilitate the creation of custom
"UNIX-utilities-as-a-service" by using a registry pattern to store the
individual builder-factory objects which are used to create a command.

The result is code which is clear and straightforward:

```java
private void handlePOST(HttpExchange t, String unixUtility) throws IOException {
    UnixUtilityBuilderFactoryRegistrySingleton registry =
        UnixUtilityBuilderFactoryRegistrySingleton.getInstance();
    Optional<UnixUtilityBuilderFactory> builderFactory =
        registry.retrieve(unixUtility);

    if (builderFactory.isPresent()) {
        try {
            Document doc = DocumentBuilderFactory
                .newInstance()
                .newDocumentBuilder()
                .parse(t.getRequestBody());

            UnixUtility uu = buildProcessByXMLSpecification(builderFactory.get(), doc);
            String stdout = uu.execute();
            respond(t, 200, stdout);
        } catch (Exception e) {
            e.printStackTrace(System.out);
            respond(t, 500, "Internal server error");
        }
    } else {
        respond(t, 404, "Not found");
    }
}

private void handlePUT(HttpExchange t, String unixUtility) throws IOException {
    UnixUtilityBuilderFactoryFactorySingleton factory =
        UnixUtilityBuilderFactoryFactorySingleton.getInstance();
    UnixUtilityBuilderFactoryRegistrySingleton registry =
        UnixUtilityBuilderFactoryRegistrySingleton.getInstance();

    registry.register(unixUtility, factory.construct(unixUtility));

    respond(t, 201, "Created");
}
```

This allows us to hire less expensive developers, and push the savings
onto our customers.

We also avoid anything not provided by the Java standard library for
the same reason: to lower the barrier to entry and make hiring new
talent easier.  This is why our API uses XML rather than the more
popular JSON.  Java developers are familiar with XML, so parsing an
API call is simplicity itself:

```java
private UnixUtility buildProcessByXMLSpecification(UnixUtilityBuilderFactory builderFactory, Document doc) {
    UnixUtilityBuilder builder = builderFactory.construct();

    NodeList args = doc.getElementsByTagName("argument");
    for (int i = 0; i < args.getLength(); i++) {
        builder.addArgument(((Element) args.item(i)).getTextContent());
    }

    NodeList in = doc.getElementsByTagName("stdin");
    for (int i = 0; i < in.getLength(); i++) {
        builder.addLineOfInput(((Element) in.item(i)).getTextContent());
    }

    return builder.build();
}
```

We hope you will consider `sed`-as-a-service for your `sed` needs.

---

The complete `sed`-as-a-service source code can be found [on GitHub][].

[on GitHub]: https://github.com/barrucadu/sed-as-a-service
