---
title: irc-client-1.0.0.0
tags: haskell, irc-client, programming, release notes
date: 2017-09-22
audience: General
notice: irc-client is a Haskell library for writing, you guessed it, IRC clients.
---

Version [1.0.0.0][] of my [irc-client][] library has just been pushed
to Hackage.  This is a super-major release which changes just about
everything, so rather than try to write a changelog, I'll give a
general introduction to the package.

[1.0.0.0]: http://hackage.haskell.org/package/irc-client-1.0.0.0
[irc-client]: https://github.com/barrucadu/irc-client

---

irc-client is a library for writing event-driven IRC clients.  It
supports both plaintext and TLS.  A simple client which joins a
channel and prints everything to stdout looks like this:

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Control.Lens
import Network.IRC.Client

main :: IO ()
main = do
  let conn = tlsConnection (WithDefaultConfig "irc.freenode.net" 6697)
               & logfunc .~ stdoutLogger
  let cfg = defaultInstanceConfig "nickname"
              & channels .~ ["#channel"]
  runClient conn cfg ()
```

At the heart of the library is an event loop: a message is received,
and every matching event handler is launched.  Event handlers can be
stateful.

We can make a client which keeps track of a counter like so:

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Control.Lens
import Control.Monad.State
import Data.Monoid
import Data.Text
import Network.IRC.Client

main :: IO ()
main = do
  let conn = tlsConnection (WithDefaultConfig "irc.freenode.net" 6697)
               & logfunc .~ stdoutLogger
  let cfg = defaultInstanceConfig "nickname"
              & channels .~ ["#channel"]
              & handlers %~ (counter:)
  runClient conn cfg 0

counter :: EventHandler Int
counter =
  let increments = ["inc", "increment", "++", "+1"]
      decrements = ["dec", "decrement", "--", "-1"]
      go src f = do
        a' <- state (\a -> (f a, f a))
        replyTo src ("new count is " <> pack (show a'))
  in EventHandler (matchType _Privmsg) $ \src message -> case message of
      (_, Right str)
        | str `elem` increments -> go src (\x -> x + 1)
        | str `elem` decrements -> go src (\x -> x - 1)
      _ -> pure ()
```

The third parameter of `runClient` is the initial state.  In our first
client, we had no state, so we used `()`.  Here we're keeping track of
an integer, so we start with `0`.  This state is exposed by a
`MonadState` instance, and can be atomically updated with `state` (STM
is used under the hood).

Event handlers are run in sequence.  If one blocks, everything after
it is stalled.  If you want a long-running task from an event handler,
you can fork a thread which will be killed when the client
disconnects:

```haskell
fork :: IRC s () -> IRC s ThreadId
```

The `runClient` call will block until the client disconnects.  If you
want to incorporate your client into some larger program, you can get
a handle to interact with it from a normal `IO` thread:

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Control.Concurrent
import Control.Lens
import Network.IRC.Client

main :: IO ()
main = do
  let conn = tlsConnection (WithDefaultConfig "irc.freenode.net" 6697)
               & logfunc .~ stdoutLogger
  let cfg = defaultInstanceConfig "nickname"
              & channels .~ ["#channel"]
              & handlers %~ (yourHandlers++)
  ircstate <- newIRCState conn cfg initialState
  forkIO (runClientWith ircstate)
  -- you can now use runIRCAction with the ircstate value to interact with the client
  -- eg:
  runIRCAction disconnect ircstate
```

Well, that's the basics.  You can [read the docs][1.0.0.0] to get all
the details, and feel free to talk to me on IRC or [open an issue][]
if you have any questions.

[open an issue]: https://github.com/barrucadu/irc-client
