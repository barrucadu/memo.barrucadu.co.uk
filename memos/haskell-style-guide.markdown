---
title: Haskell Style Guide
tags: programming
date: 2017-05-16
---

File layout
-----------

The different elements of a sample file have been identified below:

```haskell
{-# LANGUAGE LambdaCase #-}                                                     -- (1)
{-# LANGUAGE TypeFamilies #-}

-- |                                                                            -- (2)
-- Module      : Test.Spec.Rename
-- Copyright   : (c) 2017 Michael Walker
-- License     : MIT
-- Maintainer  : Michael Walker <mike@barrucadu.co.uk>
--
-- Functions for projecting expressions into a consistent namespace.
module Test.Spec.Rename                                                         -- (3)
  ( -- * Projections
    projections
  , rename
  , allRenamings
  -- ** The @These@ type
  , These(..)
  ) where

import           Control.Arrow  (second)                                        -- (4)
import qualified Data.Typeable  as T

import           Test.Spec.Expr (Expr, environment)
import           Test.Spec.Type (rawTypeRep)

-- | The @These@ type is like 'Either', but also has the case for when          -- (5)
-- we have both values.
data These a b
  = This a
  | That b
  | These a b
  deriving (Eq, Show)


------------------------------------------------------------------------------- -- (6)
-- Projections

-- | Find all type-correct ways of associating environment variables.
projections :: Expr s1 m1 h1 -> Expr s2 m2 h2 -> [[(These String String, TypeRep)]]
projections e1 e2 = projectionsFromEnv (env e1) (env e2) where
  env = map (second rawTypeRep) . environment
```

1. Language pragmas:
    - Alphabetical order
    - One per line
    - Do not align the closing `#-}`s
2. Module header:
    - Do not use the `stability` or `portability` fields
3. Export list:
    - One entry per line, with Haddock-style headings (`-- *`, `-- **`, and so on) to divide it up
    - The list may be omitted for small or internal modules
4. Imports:
    - Split into two groups: modules from outside the project and modules from inside the project
    - Add sufficient spacing between the `import` and the module name to include the `qualified`
      keyword
    - Align import lists and `as` qualifications across both groups (even though there is a blank
      line)
    - If only importing instances, use this style: `import Foo.Instances ()`
    - Put as many import specs on same line as possible, wrapping at 80 characters
    - Align import list on lines after the import under the start of the module name
    - There is no space between classes/types and the list of its members:
      `import Data.Foldable (Foldable(fold))`
5. Definitions:
    - One blank line between definitions
6. Separators:
    - Definitions may be separated into named groups, where a group starts with two blank lines, a
      sequence of 79 '-'s, a title, and another single blank line
    - Consider multiple modules, if one file has many groups
    - Groups do not need to correspond exactly to sections in the export list: the export list is
      for users of the module, the groups are for its developers

Furthermore, lines should use UNIX-style (lf) line endings and have no trailing whitespace.  The
file should end with a single newline.

[stylish-haskell][] should be used to format the language pragmas, imports, and whitespace.  The
bullet points are just an English-language description of the effect of this configuration:

```yaml
steps:
  - imports:
      align: global
      list_align: after_alias
      long_list_align: inline
      empty_list_align: right_after
      list_padding: module_name
      separate_lists: false

  - language_pragmas:
      style: vertical
      align: false
      remove_redundant: true

  - trailing_whitespace: {}

columns: 80

newline: lf
```

[stylish-haskell]: https://github.com/jaspervdj/stylish-haskell

In case of doubt, the tool takes precedence.


Formatting
----------

One day I'd like to use a tool to format all my code for me (like [gofmt][] or [rustfmt][]), but:

- [hindent][] is [unusable][] and I just dislike its output, which is particularly unfortunate as it
  supports almost no configuration.
- [brittany][] is nice, but still in early stages.

[gofmt]:    https://golang.org/cmd/gofmt/
[rustfmt]:  https://github.com/rust-lang-nursery/rustfmt
[hindent]:  https://github.com/commercialhaskell/hindent
[unusable]: https://github.com/commercialhaskell/hindent/issues/220
[brittany]: https://github.com/lspitzner/brittany

### Line length

Soft limit of 80 characters, harder limit of 110 characters, no absolute limit.

Lines longer than 80 characters are acceptable if breaking the line would introduce ugliness in some
other way.

### Alignment

Similar items on *adjacent* lines *may* be surrounded with extra spaces to align them, if doing so
would not introduce a large amount of extra spacing.  Items on lines which are not adjacent,
ignoring lines consisting solely of whitespace or comments, should not be aligned.

Good:

```haskell
instance NFData DPOR where
  rnf dpor = rnf ( dporRunnable dpor
                 , dporTodo     dpor
                 , dporDone     dpor
                 , dporSleep    dpor
                 , dporTaken    dpor
                 , dporAction   dpor
                 )
```

Bad:

```haskell
case rest of
  ((_, runnable, _):_) -> map fst runnable
  []                   -> []
```

Very bad:

```haskell
case M.lookup tid' (dporDone dpor) of
  Just dpor' ->
    let done = M.insert tid' (grow state' tid' rest dpor') (dporDone dpor)
    in dpor { dporDone = done }
  Nothing    ->
    let taken = M.insert tid' a (dporTaken dpor)
    in dpor { dporTaken = if conservative then dporTaken dpor else taken }
```

### Indentation

Do not use tabs, indent with spaces.  Use two spaces for each indentation level.

```haskell
canInterrupt :: DepState -> ThreadId -> ThreadAction -> Bool
canInterrupt depstate tid act
  | isMaskedInterruptible depstate tid = case act of
    BlockedPutMVar  _ -> True
    BlockedReadMVar _ -> True
    BlockedTakeMVar _ -> True
    BlockedSTM      _ -> True
    BlockedThrowTo  _ -> True
    _ -> False
  | isMaskedUninterruptible depstate tid = False
  | otherwise = True

autocheckWayIO :: (Eq a, Show a) => Way -> MemType -> ConcIO a -> IO Bool
autocheckWayIO way memtype concio =
  dejafusWayIO way memtype concio autocheckCases
```

### Type signatures

If a type signature is too long to fit on a single line, or you want to add comments to the
individual parameters, it can be broken over multiple lines.

Indentation is with two spaces, and includes the `::` or `=>` (for the first parameter) and `->`
(for subsequent parameters).

```haskell
incorporateTrace
  :: MemType
  -- ^ Memory model
  -> Bool
  -- ^ Whether the \"to-do\" point which was used to create this new
  -- execution was conservative or not.
  -> Trace
  -- ^ The execution trace: the decision made, the runnable threads,
  -- and the action performed.
  -> DPOR
  -> DPOR
```

Typeclass constraints should remain on the same line as the function name:

```haskell
runSCT :: MonadRef r n
  => Way
  -- ^ How to run the concurrent program.
  -> MemType
  -- ^ The memory model to use for non-synchronised @CRef@ operations.
  -> ConcT r n a
  -- ^ The computation to run many times.
  -> n [(Either Failure a, Trace)]
```

### Data declarations

If there are multiple constructors, break over lines like so:

```haskell
data Way where
  Systematically :: Bounds -> Way
  Randomly :: RandomGen g => g -> Int -> Way

data IdSource = Id
  { _nextCRId  :: Int
  , _nextMVId  :: Int
  , _nextTVId  :: Int
  , _nextTId   :: Int
  , _usedCRNames :: [String]
  , _usedMVNames :: [String]
  , _usedTVNames :: [String]
  , _usedTNames  :: [String]
  }
  deriving (Eq, Ord, Show)

data ThreadAction
  = Fork ThreadId
  | MyThreadId
  | GetNumCapabilities Int
  | SetNumCapabilities Int
  | Yield
  deriving (Eq, Show)
```

The `deriving` clause comes on a new line with one level of indentation.

### Type declarations

If the original type is too long to fit on a single line, break it up just as you would a function
type signature:

```haskell
type Scheduler state
  = [(Decision, ThreadAction)]
  -> Maybe (ThreadId, ThreadAction)
  -> NonEmpty (ThreadId, Lookahead)
  -> state
  -> (Maybe ThreadId, state)
```

### List and tuple declarations

Align the elements in the list, with commas and brackets on the left:

```haskell
failures :: [Failure]
failures =
  [ InternalError
  , Abort
  , Deadlock
  , STMDeadlock
  , UncaughtException
  , IllegalSubconcurrency
  ]
```

You may optionally avoid the newline, if it looks better in this case:

```haskell
failures :: [Failure]
failures = [ InternalError
           , Abort
           , Deadlock
           , STMDeadlock
           , UncaughtException
           , IllegalSubconcurrency
           ]
```

Tuples larger than three elements should be avoided.  Sometimes large tuples are useful though (for
example, in writing `NFData` instances), in which case they are formatted like lists.

### Case expressions

Case expressions may be indented in either of these ways:

```haskell
(~=) :: Thread n r -> BlockedOn -> Bool
thread ~= theblock = case (_blocking thread, theblock) of
  (Just (OnMVarFull  _), OnMVarFull  _) -> True
  (Just (OnMVarEmpty _), OnMVarEmpty _) -> True
  (Just (OnTVar      _), OnTVar      _) -> True
  (Just (OnMask      _), OnMask      _) -> True
  _ -> False

stepThrow t ts act e =
  case propagate (toException e) t ts of
    Just ts' -> simple ts' act
    Nothing
      | t == initialThread -> pure (Left UncaughtException, Single act)
      | otherwise -> simple (kill t ts) act
```

### Pragmas

Put pragmas between the type signature and the definition of the function they apply to.

```haskell
concatPartition :: (a -> Bool) -> [[a]] -> ([a], [a])
{-# INLINE concatPartition #-}
concatPartition p = foldl (foldr select) ([], []) where
  select a ~(ts, fs)
    | p a       = (a:ts, fs)
    | otherwise = (ts, a:fs)
```

If the function has no type signature (it's a local definition in a `where` clause, for instance),
put the pragma immediately before.

### Hanging lambdas

Lines after a hanging lambda should be indented:

```haskell
forkFinally :: MonadConc m => m a -> (Either SomeException a -> m ()) -> m (ThreadId m)
forkFinally action and_then =
  mask $ \restore ->
    fork $ Ca.try (restore action) >>= and_then
```

### `where` clauses

If a function contains a `where` clause, the `where` should be on the opening line of the function,
if short enough:

```haskell
representative :: Eq a => Predicate a -> Predicate a
representative p xs = result { _failures = choose . collect $ _failures result } where
  result  = p xs
  collect = groupBy' [] ((==) `on` fst)
  choose  = map $ minimumBy (comparing $ \(_, trc) -> (preEmps trc, length trc))
```

If the function body includes a linebreak, both it and the `where`-body should be indented by a
further two spaces and the `where` put on a new line:

```haskell
findInstance :: Expr s1 m1 h1 -> Expr s2 m2 h2 -> Maybe [(String, [String])]
findInstance eG eS
    | eS `isInstanceOf` eG = Just nameMap
    | otherwise = Nothing
  where
    env = map fst . environment'
    nameMap =
      map (\((s,g):sgs) -> (s, nub (g:map snd sgs))) .
      groupBy ((==) `on` fst) .
      sortOn fst $
      zip (env eS) (env eG)
```

Avoid nested `where` clauses and consider making multiple top-level definitions instead.

### `let` expressions

Multiple lines inside the `let` and `in` should be aligned:

```haskell
grow state tid trc@((d, _, a):rest) dpor =
  let tid'   = tidOf tid d
      state' = updateDepState state tid' a
  in case M.lookup tid' (dporDone dpor) of
       Just dpor' ->
         let done = M.insert tid' (grow state' tid' rest dpor') (dporDone dpor)
         in dpor { dporDone = done }
       Nothing ->
         let taken = M.insert tid' a (dporTaken dpor)
             sleep = dporSleep dpor `M.union` dporTaken dpor
             done  = M.insert tid' (subtree state' tid' sleep trc) (dporDone dpor)
         in dpor { dporTaken = if conservative then dporTaken dpor else taken
                 , dporTodo  = M.delete tid' (dporTodo dpor)
                 , dporDone  = done
                 }
grow _ _ [] _ = err "incorporateTrace" "trace exhausted without reading a to-do point!"
```

### `if-then-else` expressions

Guards and pattern matches should be preferred over `if-then-else` expressions generally, use your
judgement.

Outside of `do`-notation, if the entire expression does not fit on a single line, the `then` and
`else` should begin in the same column as the `if`:

```haskell
($$) :: Ord h => Expr s m h -> Expr s m h -> Maybe (Expr s m h)
f $$ e = case funTys (exprTypeRep f) of
    Just (fArgTy, fResTy) ->
      if fArgTy == ignoreTypeRep && isJust (unmonad $ exprTypeRep e)
      then mkfun fResTy
      else mkfun =<< exprTypeRep f `funResultTy` exprTypeRep e
    Nothing -> Nothing
```

In `do`-notation the `then` and `else` should be indented another level:

```haskell
checkFile :: (MonadError FileError m, MonadIO m) => FileConfig -> FilePath -> Int64 -> m ()
checkFile fcfg fname bytes = do
  let maxbytes = maxSizeInBytes fcfg
  if bytes > maxbytes
    then throwError (FileTooLarge bytes maxbytes)
    else do
      ok <- liftIO (additionalRules fcfg fname)
      case ok of
        Right _ -> pure ()
        Left  e -> throwError (FileDisallowed e)
```


Naming
------

Use camelCase for values and PascalCase for types and constructors.

Don't capitalise all letters when using an abbreviation: `HttpServer`, not `HTTPServer`.  Two-letter
acronyms are an exception to this.

For type variables be consistent across type signatures, and consider a (short) name if there is one
more meaningful than just a single letter.

```haskell
check :: MonadSTM stm => Bool -> stm ()

throwSTM :: (MonadSTM stm, Exception e) => e -> stm a

catchSTM :: (MonadSTM stm, Exception e) => stm a -> (e -> stm a) -> stm a

liftedOrElse :: (MonadTransControl t, MonadSTM stm)
  => (forall x. StT t x -> x)
  -> t stm a -> t stm a -> t stm a
```

Primes may be used to indicate that two values are related.  The number 0 may be used as a suffix to
indicate that a value is "initial" or "default" in some way.

```haskell
evaluateDyn :: Monad m => Term s m -> [(String, Dynamic s m)] -> Maybe (s -> Dynamic s m)
evaluateDyn e0 globals
    | all check (environment e0) = Just (go [] e0)
    | otherwise = Nothing
  where
    go _ (Lit _ _ dyn) _ = dyn
    go locals (Var _ var) _ = env locals var
    go locals (Let ty True _ b e) s =
      let mx = unwrapMonadicDyn (go locals b s)
      in unsafeWrapMonadicDyn ty $ mx >>= \x -> unwrapMonadicDyn (go (x:locals) e s)
    go locals (Let _ False _ b e) s =
      let x = go locals b s
      in go (x:locals) e s
    go locals (Ap _ f e) s =
      let f' = go locals f s
          e' = go locals e s
      in f' `dynApp` (if ignoreArg f' then ignore e' else e')
    go _ StateVar s = toDyn s
```

Numbers greater than 0 may be used to indicate two values are similar but unrelated.

```haskell
dependent :: MemType -> DepState -> (ThreadId, ThreadAction) -> (ThreadId, ThreadAction) -> Bool
dependent memtype ds (t1, a1) (t2, a2) = case rewind a2 of
  Just l2
    | isSTM a1 && isSTM a2 ->
      not . S.null $ tvarsOf a1 `S.intersection` tvarsOf a2
    | not (isBlock a1 && isBarrier (simplifyLookahead l2)) ->
      dependent' memtype ds t1 a1 t2 l2
  _ -> dependentActions memtype ds (simplifyAction a1) (simplifyAction a2)
```


Comments
--------

Write correctly punctuated and spelled English sentences.  Haddock comments should have one space
between the starting symbol and the text:

```haskell
-- | This is good.

-- |This is bad.
```

Haddock comments on type parameters and data constructors should use the `-- ^` style (not the
`-- |` style):

```haskell
incorporateTrace
  :: MemType
  -- ^ Memory model
  -> Bool
  -- ^ Whether the \"to-do\" point which was used to create this new
  -- execution was conservative or not.
  -> Trace
  -- ^ The execution trace: the decision made, the runnable threads,
  -- and the action performed.
  -> DPOR
  -> DPOR

-- | The scheduler state
data DPORSchedState = DPORSchedState
  { schedSleep     :: Map ThreadId ThreadAction
  -- ^ The sleep set: decisions not to make until something dependent
  -- with them happens.
  , schedPrefix    :: [ThreadId]
  -- ^ Decisions still to make
  , schedBPoints   :: Seq (NonEmpty (ThreadId, Lookahead), [ThreadId])
  -- ^ Which threads are runnable at each step, and the alternative
  -- decisions still to make.
  , schedIgnore    :: Bool
  -- ^ Whether to ignore this execution or not: @True@ if the
  -- execution is aborted due to all possible decisions being in the
  -- sleep set, as then everything in this execution is covered by
  -- another.
  , schedBoundKill :: Bool
  -- ^ Whether the execution was terminated due to all decisions being
  -- out of bounds.
  , schedDepState  :: DepState
  -- ^ State used by the dependency function to determine when to
  -- remove decisions from the sleep set.
  }
  deriving (Eq, Show)
```


Warnings and linting
--------------------

Code should compile with `-Wall` with no warnings *except* for unnecessary imports, if you support
multiple versions of libraries which have changed their API.  Don't introduce CPP simply to avoid warnings.

Use [hlint][] to lint your code, this `.hlint.yaml` configuration file will work for version 2 and
later:

```yaml
# Module export lists should generally be preferred, but may be
# omitted if the module is small or internal.
- ignore: {name: Use module export list}

# Record patterns are just ugly.
- ignore: {name: Use record patterns}

# Prefer applicative operators over monadic ones.
- suggest: {name: Generalise monadic functions, lhs: return, rhs: pure}
```

[hlint]: https://github.com/ndmitchell/hlint

All lints should be fixed.  However, sometimes hlint is too zealous, and there is a genuine reason
why a lint cannot be fixed.  Such cases may be added to the configuration file with a comment
explaining why:

```yaml
# GHC treats infix $ specially wrt type checking, so that things like
# "runST $ do ..." work even though they're impredicative.
# Unfortunately, this means that HLint's "avoid lambda" warning for
# this module would lead to code which no longer compiles!
- ignore: {name: Avoid lambda, within: Test.DejaFu.Conc}
```

Remember the comment!  You are creating a tooling-approved code smell!
