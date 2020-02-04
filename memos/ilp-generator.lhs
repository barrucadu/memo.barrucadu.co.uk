---
title: A little programming language for integer linear programming
tags: haskell, maths, programming
date: 2019-06-29
---

Integer linear programming (ILP) is [a good fit for making rotas][ilp].
Expressing rota constraints as mathematical expressions is concise and
easy to read.  When translated into code, however, it's not so nice.
The [PuLP][] library does a pretty good job, but it's more verbose.

Here are a pair of constraints from the [Solving Scheduling Problems
with Integer Linear Programming][ilp] memo about [fairly distributing
rota assignments amongst the available people][fair]:

```raw
\[
\forall t \in \mathcal T \text{, }
\forall p \in \mathcal P \text{, }
\forall r \in \mathcal R \text{, }
X_p \geqslant A_{tpr}
\]

\[
\forall p \in \mathcal P \text{, }
X_p \leqslant \sum_{t \in \mathcal T} \sum_{r \in \mathcal R} A_{tpr}
\]
```

It's a bit dense, but it only has the necessary information.  Now
here's the corresponding Python:

```python
for slot in range(slots):
    for person in people:
        for role in roles:
            problem += is_assigned[person] >= assignments[slot, person, role]

for person in people:
    problem += is_assigned[person] <= pulp.lpSum(assignments[slot, person, role] for slot in range(slots) for role in roles)
```

That's a bit more verbose, takes up more space, we've got this
`pulp.lpSum` thing, this mysterious `problem` variable..  I'd prefer
to be able to write an ASCII equivalent of the mathematical form, and
have the Python generated for me.

The source file for this memo is Literate Haskell, you can load it
directly into GHCi.  So here's the necessary ceremony:

> {-# LANGUAGE LambdaCase #-}
> {-# LANGUAGE GADTs #-}
>
> import Control.Monad.Trans.Class
> import Control.Monad.Trans.Except
> import Control.Monad.Trans.Reader
> import Control.Monad.Trans.State
>
> import Data.Foldable (for_)
> import Data.List     (intercalate, sort)
> import Data.Maybe    (listToMaybe)

Let's begin!

[ilp]: scheduling-problems.html
[PuLP]: https://pythonhosted.org/PuLP/
[fair]: scheduling-problems.html#assignments-are-fairly-distributed


Concrete syntax
---------------

My main motivation when coming up with the concrete syntax was "it
should look like the maths, but be ASCII, and not be LaTeX because
that would be a pain".  It should also be concise, in particular it
shouldn't be necessary to specify what type quantifiers range over
(that should be inferred).

I'm going to use the basic rota generator described in [the other
memo][ilp] as a running example.

An ILP language is, necessarily, not very expressive.  So I decided on
the following types:

- User-defined types (sets of values)
- Predicates
- Integers
- N-dimensional binary arrays
- N-dimensional integer arrays[^integer_arr]

[^integer_arr]: I've not implemented these because the example didn't
  need them.

Predicates take parameters and arrays take indices, the types of these
will also be modelled.  A predicate which takes two integers is a
different type to a predicate which takes an integer and a set-value.

We also want to distinguish between "parameter" variables, which the
user of the model will supply, and "model" variables, which the model
will solve for.

Here's an example with some comments:

```
-- Define three new types
type TimeSlot, Person, Role

-- M is an input of type integer
param integer M

-- is_leave is an input of type (TimeSlot, Person) -> bool
param predicate is_leave(TimeSlot, Person)

-- A is a 3D binary array the solver will try to produce
model binary A[TimeSlot, Person, Role]

-- X is a 1D binary array (or "vector" if you like special-case
-- terminology...)  the solver will try to produce
model binary X[Person]
```

Now we have our constraints and objective function:

```
-- In every time slot, each role is assigned to exactly one person
forall t, r; sum{p} A[t,p,r] = 1

-- Nobody is assigned multiple roles in the same time slot
forall t, p; sum{r} A[t,p,r] <= 1

-- Nobody is assigned a role in a slot they are on leave for
forall p, t if is_leave(t,p), r; A[t,p,r] = 0

-- Nobody works too many shifts
forall p; sum{t, r} A[t,p,r] <= M

-- Assignments are fairly distributed
forall t, p, r; X[p] >= A[t,p,r]
forall p; X[p] <= sum{t} r A[t,p,r]

maximise sum{p} X[p]
```

Look how concise they are!  They don't reference any types either!

Even though `forall` and `sum` are conceptually similar (bring a new
variable into scope and do some sort of quantification) I picked
different syntax for them because `forall` introduces multiple actual
constraints: one for each value of the user-defined type being
quantified over.  The `forall` quantifier is part of the
meta-language, the `sum` quantifier is part of the ILP language.


Abstract syntax
---------------

Let's talk abstract syntax.  I didn't want to write a parser, so we'll
skip over that.  We're now getting to our first real bit of Haskell
code.

In the concrete syntax there's only one `forall` and it's followed by
a list of variables to quantify over, and then the constraint.  To
simplify the implementation, the abstract-syntax-`CForall` has exactly
one variable, and can either be followed by another `CForall` or a
`CCheck` (the bit like `sum{r} A[t,p,r] <= 1`).

A `CForall` also contains an optional predicate restriction, which is
expressed as the predicate's name followed by the list of arguments.

> type Name = String
>
> data Constraint a
>   = CForall (TypedName a) (Maybe (Name, [Name])) (Constraint a)
>   | CCheck Op (Expression a) (Expression a)
>   deriving Eq
>
> data Op = OEq | OLt | OGt | OLEq | OGEq
>   deriving Eq

We'll talk about the `TypedName` bit in the next section, but it's
essentially the name of the quantifier variable.  Here are some
examples, where `E1` and `E2` are placeholders for expressions:

- **concrete:** `E1 <= E2`

  **abstract:** `CCheck OEq E1 E2`

- **concrete:** `forall x; E1 = E2`

  **abstract:** `CForall (Untyped "x") Nothing (CCheck OEq E1 E2)`

- **concrete:** `forall x, y if p(x, y); E1 < E2`

  **abstract:** `CForall (Untyped "x") Nothing (CForall (Untyped "y") (Just ("p", ["x", "y"])) (CCheck OLt E1 E2))`

The expression language is a bit richer, there are more forms of
expressions than there are constraints:

> data Expression a
>   = ESum (TypedName a) (Expression a)
>   | EIndex Name [Name]
>   | EVar Name
>   | EConst Integer
>   | EMul Integer (Expression a)
>   | EAdd (Expression a) (Expression a)
>   deriving Eq

Here are some more examples:

- **concrete:** `1 + 2`

  **abstract:** `EAdd (EConst 1) (EConst 2)`

- **concrete:** `X[y,z]`

  **abstract:** `EIndex "X" ["y", "z"]`

- **concrete:** `3 * sum{i} X[i]`

  **abstract:** `EMul 3 (ESum (Untyped "i") (EIndex "X" ["i"]))`

Reading terms expressed in this abstract syntax would be a bit of a
pain, so here's some pretty-printing:

> instance Show (Constraint a) where
>   show (CForall tyname (Just (rname, rargs)) c) =
>     "forall " ++ show tyname ++ " if " ++ rname ++ "(" ++ strings rargs ++ "); " ++ show c
>   show (CForall tyname _ c) = "forall " ++ show tyname ++ "; " ++ show c
>   show (CCheck op expr1 expr2) = show expr1 ++ " " ++ show op ++ " " ++ show expr2
>
> instance Show (Expression a) where
>   show (ESum tyname expr) = "sum{" ++ show tyname ++ "} " ++ show expr
>   show (EIndex name args) = name ++ "[" ++ strings args ++ "]"
>   show (EVar name) = name
>   show (EConst i) = show i
>   show (EMul i expr) = show i ++ " * " ++ show expr
>   show (EAdd expr1 expr2) = show expr1 ++ " + " ++ show expr2
>
> instance Show Op where
>   show OEq = "="
>   show OLt = "<"
>   show OGt = ">"
>   show OLEq = "<="
>   show OGEq = ">="

It looks like this:

```
λ> CForall (Untyped "x") Nothing
   (CForall (Untyped "y") (Just ("p", ["x", "y"]))
     (CCheck OLt
       (EMul 3 (ESum (Untyped "i") (EIndex "X" ["i"])))
       (EConst 10)))
forall x; forall y if p(x, y); 3 * sum{i} X[i] < 10
```

The `strings` helper function used in `CForall` and `EIndex` just
comma-separates a list of strings:

> strings :: [String] -> String
> strings = intercalate ", "



Type system
-----------

Previously, I said we would have these types:

- User-defined types
- Predicates
- Integers
- N-dimensional binary arrays
- N-dimensional integer arrays (not actually implemented)

And we also need to distinguish between "parameter" variables and
"model" variables.  ILP solvers only operate on matrices, so actually
what we have are three parameter types:

- User-defined types
- Predicates
- Integers

And two model types:

- N-dimensional binary arrays
- N-dimensional integer arrays

> data Ty
>   = ParamCustom Name | ParamInteger | ParamPredicate [Ty]
>   | ModelBinary [Ty]
>   deriving Eq

Remember the `TypedName` in the constraint and expression abstract
syntax?  It was used wherever a new name was brought into scope:
`CForall` and `ESum`.  A `TypedName` is either a `Name` by itself or a
`Name` associated with a `Ty`:

> data IsTyped
> data IsUntyped
>
> data TypedName a where
>   Untyped :: Name       -> TypedName IsUntyped
>   Typed   :: Name -> Ty -> TypedName IsTyped
>
> instance Eq (TypedName a) where
>   Untyped n1 == Untyped n2 = n1 == n2
>   Typed n1 ty1 == Typed n2 ty2 = n1 == n2 && ty1 == ty2

When generating code, we'll need to know which types are being
quantified over.  So the type checker will fill in the types as it
goes, turning our *untyped* expressions and constraints into *typed*
expressions and constraints.

> type UntypedConstraint = Constraint IsUntyped
> type UntypedExpression = Expression IsUntyped
> type TypedConstraint = Constraint IsTyped
> type TypedExpression = Expression IsTyped

And let's add some pretty-printing for types too:

> instance Show Ty where
>   show (ParamCustom name) = "param<" ++ name ++ ">"
>   show ParamInteger = "param<integer>"
>   show (ParamPredicate args) = "param<predicate(" ++ strings (map show args) ++ ")>"
>   show (ModelBinary args) = "model<binary[" ++ strings (map show args) ++ "]>"
>
> instance Show (TypedName a) where
>   show (Untyped name) = name
>   show (Typed name ty) = show ty ++ " " ++ name


Running example
---------------

Our running example is the set of basic rota constraints from [the
other memo][ilp].  We've already seen the concrete syntax, here's the
abstract syntax:

> type Binding = (Name, Ty)
>
> globals :: [Binding]
> globals =
>   [ ("M", ParamInteger)
>   , ("is_leave", ParamPredicate [ParamCustom "TimeSlot", ParamCustom "Person"])
>   , ("A", ModelBinary [ParamCustom "TimeSlot", ParamCustom "Person", ParamCustom "Role"])
>   , ("X", ModelBinary [ParamCustom "Person"])
>   ]
>
> constraints :: [UntypedConstraint]
> constraints =
>   [ -- In every time slot, each role is assigned to exactly one person
>     CForall (Untyped "t") Nothing
>     (CForall (Untyped "r") Nothing
>       (CCheck OEq
>         (ESum (Untyped "p") (EIndex "A" ["t", "p", "r"]))
>         (EConst 1)))
>     -- Nobody is assigned multiple roles in the same time slot
>   , CForall (Untyped "t") Nothing
>     (CForall (Untyped "p") Nothing
>       (CCheck OLEq
>         (ESum (Untyped "r") (EIndex "A" ["t", "p", "r"]))
>         (EConst 1)))
>     -- Nobody is assigned a role in a slot they are on leave for
>   , CForall (Untyped "p") Nothing
>     (CForall (Untyped "t") (Just ("is_leave", ["t", "p"]))
>       (CForall (Untyped "r") Nothing
>         (CCheck OEq
>          (EIndex "A" ["t", "p", "r"])
>          (EConst 0))))
>     -- Nobody works too many shifts
>   , CForall (Untyped "p") Nothing
>     (CCheck OLEq
>       (ESum (Untyped "t") (ESum (Untyped "r") (EIndex "A" ["t", "p", "r"])))
>       (EVar "M"))
>     -- Assignments are fairly distributed
>   , CForall (Untyped "t") Nothing
>     (CForall (Untyped "p") Nothing
>       (CForall (Untyped "r") Nothing
>         (CCheck OGEq
>          (EIndex "X" ["p"])
>          (EIndex "A" ["t", "p", "r"]))))
>   , CForall (Untyped "p") Nothing
>     (CCheck OLEq
>       (EIndex "X" ["p"])
>       (ESum (Untyped "t") (ESum (Untyped "r") (EIndex "A" ["t", "p", "r"]))))
>   ]

That's pretty verbose, more than the Python!  Good thing that I'd
write a parser for this if I were doing it for real.


Type checking and inference
---------------------------

This is the hairy bit of the memo.  I've not gone for any particular
type inference algorithm, I just went for the straightforward way to
do it for the syntax and types I had.

We'll use a monad stack for the type checker:

> type TcFun = ReaderT [Binding] (StateT [Binding] (Except String))
> -- environment       ^^^^^^^^^
> -- unresolved free variables           ^^^^^^^^^
> -- error message                                         ^^^^^^

To get a feel for how `TcFun` is useful, let's go through some utility
functions.

**Type errors:**

> typeError :: String -> TcFun a
> typeError = lift . lift . throwE
>
> eExpected :: String -> Name -> Maybe Ty -> TcFun a
> eExpected eTy name (Just aTy) = typeError $
>   "Expected " ++ eTy ++ " variable, but '" ++ name ++ "' is " ++ show aTy ++ " variable."
> eExpected eTy name Nothing = typeError $
>   "Expected " ++ eTy ++ " variable, but could not infer a type for '" ++ name ++ "'."

Throwing a type error is pretty important, so we'll need a function
for that, and for one of the more common errors.

**Looking up the type of a name (if it's bound):**

> getTy :: Name -> TcFun (Maybe Ty)
> getTy name = lookup name <$> ask

The bindings in the state are just to keep track of free variables,
and are not used when checking something's type.

**Running a subcomputation with a name removed from the environment:**

> withoutBinding :: Name -> TcFun a -> TcFun a
> withoutBinding name = withReaderT (remove name)

For example, if we have a global `x` and a constraint `forall x;
A[x]`, the `x` in `A[x]` is not the global `x`; it's the `x` bound by
the `forall`.  Don't worry, it's only removed while typechecking the
body of the `CForall` or `ESum` which introduced the new binding.

**Asserting a variable has a type:**

> assertType :: Name -> Ty -> TcFun ()
> assertType name eTy = getTy name >>= \case
>   Just aTy
>     | eTy == aTy -> pure ()
>     | otherwise -> eExpected (show eTy) name (Just aTy)
>   Nothing -> lift $ modify ((name, eTy):)

Takes a name and an expected type, and checks that any pre-existing
binding matches.  If there is no pre-existing binding, the name is
introduced as a free variable.

**Removing a free variable from the state:**

> delFree :: Name -> TcFun Ty
> delFree name = lookup name <$> lift get >>= \case
>   Just ty -> do
>     lift $ modify (remove name)
>     pure ty
>   Nothing -> typeError $
>     "Could not infer a type for '" ++ name ++ "'."

Looks up the type of a free variable, removes the variable from the
state, and returns the type.  If we fail to find a type for the
variable, it's unused, which is a type error (as we can't infer a
concrete type).

---

The basic idea is to walk through the abstract syntax: unify types
when they arise; and for `CForall` and `ESum` check that the inner
constraint (or expression) has a free variable with the right name and
type.

**Typechecking argument lists:**

Let's start with the simplest case: type checking an argument list,
which arises in quantifier predicate constraints and `EIndex`.  The
function takes the names of the argument variables and their expected
types, and checks that the variables do have those types.

> typecheckArgList :: [Name] -> [Ty] -> TcFun ()

The recursive case takes the name of the current argument and its
expected type.  It then looks up the actual type of the name.  If it
has a type, check that it's the same as the expected type and either
move onto the next parameter or throw an error.  If there is no
binding, `assertType` records it as a free variable.

> typecheckArgList (name:ns) (expectedTy:ts) = do
>   assertType name expectedTy
>   typecheckArgList ns ts

Ultimately the `typecheckExpression` and `typecheckConstraint`
functions we'll get to later will make sure all these free variables
are bound by a `forall` or a `sum`.

The base case is when we run out of argument names or types; there
should be the same number of each:

> typecheckArgList [] [] = pure ()
> typecheckArgList ns [] = typeError $
>   "Expected " ++ show (length ns) ++ " fewer arguments."
> typecheckArgList [] ts = typeError $
>   "Expected " ++ show (length ts) ++ " more arguments."

**Typechecking expressions:**

Expressions have a few different parts, so let's go through them one
at a time.

> typecheckExpression :: UntypedExpression -> TcFun TypedExpression
> typecheckExpression e0 = decorate e0 (go e0) where

The `decorate` function, defined further below, appends the
pretty-printed expression to any error message.  So by `decorate`ing
every recursive call, we get an increasingly wide view of the error.
Like this:

```
Found variable 'x' at incompatible types param<integer> and param<index>.
    in x
    in A[x] = x
    in forall x; A[x] = x
```

`ESum` introduces a new binding.  The way I've handled this is by
*unbinding* the name (in case there was something with the same name
from a wider scope), type-checking the inner expression, and then (1)
asserting that there is a free variable with the name of the bound
variable and (2) storing its type.

>   go (ESum (Untyped name) expr) = do
>     expr' <- withoutBinding name $ typecheckExpression expr
>     delFree name >>= \case
>       ty@(ParamCustom _) -> pure (ESum (Typed name ty) expr')
>       aTy -> eExpected "param<$custom>" name (Just aTy)

`EIndex` requires checking an argument list.  I'm not allowing
quantifying over model variables, so in the expression `EIndex name
args`, then `name` *must* refer to a global.  All globals are of known
types, so we can look up the type of the argument list from the global
environment.

>   go (EIndex name args) = getTy name >>= \case
>     Just (ModelBinary argtys) -> do
>       typecheckArgList args argtys
>       pure (EIndex name args)
>     aTy -> eExpected "model<binary(_)>" name aTy

`EVar` uses a variable directly, in which case the variable *must* be
an integer.  This is handled by looking for a binding and, if there
isn't one, introducing a new free variable.

>   go (EVar name) = do
>     assertType name ParamInteger
>     pure (EVar name)

`EConst`, `EMul`, and `EAdd` are pretty simple and just involve
recursive calls to `typecheckExpression`.

>   go (EConst k) = pure (EConst k)
>
>   go (EMul k expr) = do
>     expr' <- typecheckExpression expr
>     pure (EMul k expr')
>
>   go (EAdd expr1 expr2) = do
>     expr1' <- typecheckExpression expr1
>     expr2' <- typecheckExpression expr2
>     pure (EAdd expr1' expr2')

The input to `typecheckExpression` is an `UntypedExpression` and the
output is a `TypedExpression`.  We get there by rewriting `ESum`
constructs to contain the inferred type of the quantifier variable.
This will be useful when generating code.

**Typechecking constraints:**

Typechecking a constraint is pretty much the same as typechecking an
expression.  `CForall` is like `ESum`, `CCheck` is like `EAdd`.  The
only new thing is that a `CForall` can have a predicate
constraint... but that's typechecked in the same way as an `EIndex`:
get the argument types of the predicate from the environment, and
check that against the argument variables.

Here it is:

> typecheckConstraint :: UntypedConstraint -> TcFun TypedConstraint
> typecheckConstraint c0 = decorate c0 (go c0) where
>   go (CForall (Untyped name) (Just (rname, rargs)) c) = getTy rname >>= \case
>     Just (ParamPredicate argtys) -> do
>       typecheckArgList rargs argtys
>       c' <- withoutBinding name $ typecheckConstraint c
>       ty <- delFree name
>       pure (CForall (Typed name ty) (Just (rname, rargs)) c')
>     aTy -> eExpected "param<predicate(_)>" rname aTy
>   go (CForall (Untyped name) Nothing c) = do
>     c' <- withoutBinding name $ typecheckConstraint c
>     ty <- delFree name
>     pure (CForall (Typed name ty) Nothing c')
>   go (CCheck op expr1 expr2) = do
>     expr1' <- typecheckExpression expr1
>     expr2' <- typecheckExpression expr2
>     pure (CCheck op expr1' expr2')

While `typecheckConstraint` works, it leaves something to be desired.
Here's a slightly nicer interface:

> typecheckConstraint_ :: [Binding] -> UntypedConstraint -> Either String TypedConstraint
> typecheckConstraint_ env0 c0 = check =<< runExcept (runStateT (runReaderT (typecheckConstraint c0) env0) []) where
>   check (c, []) = Right c
>   check (_, free) = Left ("Unbound free variables: " ++ strings (sort (map fst free)) ++ ".")

This:

- Takes the global bindings as an argument.
- Does away with the `TcFun`, it returns a plain `Either`.
- Checks that no free variables leak out.

---

Some utility functions used above are:

> remove :: Eq a => a -> [(a, b)] -> [(a, b)]
> remove a = filter ((/=a) . fst)
>
> decorate :: Show a => a -> TcFun b -> TcFun b
> decorate e = goR where
>   goR m = ReaderT (goS . runReaderT m)
>   goS m = StateT (goE . runStateT m)
>   goE = withExcept (\err -> err ++ "\n    in " ++ show e) where


Example: type checking and inference
------------------------------------

Here's a little function to print out the inferred type, or type
error, for all of our constraints from the running example:

> demoTypeInference :: IO ()
> demoTypeInference = for_ constraints $ \constraint -> do
>   case typecheckConstraint_ globals constraint of
>     Right c' -> print c'
>     Left err -> putStrLn err
>   putStrLn ""

Behold!

```
λ> demoTypeInference
forall param<TimeSlot> t; forall param<Role> r; sum{param<Person> p} A[t, p, r] = 1

forall param<TimeSlot> t; forall param<Person> p; sum{param<Role> r} A[t, p, r] <= 1

forall param<Person> p; forall param<TimeSlot> t if is_leave(t, p); forall param<Role> r; A[t, p, r] = 0

forall param<Person> p; sum{param<TimeSlot> t} sum{param<Role> r} A[t, p, r] <= M

forall param<TimeSlot> t; forall param<Person> p; forall param<Role> r; X[p] >= A[t, p, r]

forall param<Person> p; X[p] <= sum{param<TimeSlot> t} sum{param<Role> r} A[t, p, r]
```

Looks pretty good, all types are inferred as they should be.

Here's a broken example, which arose when I mistyped one of the
constraints:

```
λ> either putStrLn print $ typecheckConstraint_ globals
  (CForall (Untyped "t") Nothing
   (CForall (Untyped "p") Nothing
    (CForall (Untyped "r") Nothing
     (CCheck OLEq
      (EIndex "X" ["p"])
      (ESum (Untyped "t") (ESum (Untyped "r") (EIndex "A" ["t", "p", "r"])))))))

Could not infer a type for 'r'.
    in forall r; X[p] <= sum{t} sum{r} A[t, p, r]
    in forall p; forall r; X[p] <= sum{t} sum{r} A[t, p, r]
    in forall t; forall p; forall r; X[p] <= sum{t} sum{r} A[t, p, r]
```

I'd added extra `forall t` and `forall r` quantifiers, which are wrong
because those variables are bound by `sum`s.  So the types of the
`forall`-bound variables can't be inferred.


Code generation
---------------

I don't want to write (or learn) bindings to ILP solvers, I already
know PuLP so that sounds like a pain.  So what I do want to do is
generate the PuLP-using Python code the abstract syntax corresponds
to.

Most of `codegenExpression`, which produces a Python expression, is
straightforward:

> codegenExpression :: TypedExpression -> String
> codegenExpression (EIndex name args) = name ++ "[" ++ strings args ++ "]"
> codegenExpression (EVar name) = name
> codegenExpression (EConst i) = show i
> codegenExpression (EMul i expr) = show i ++ " * " ++ codegenExpression expr
> codegenExpression (EAdd expr1 expr2) = "(" ++ codegenExpression expr1 ++ " + " ++ codegenExpression expr2 ++ ")"

The complex bit is handling `ESum`, which introduces a generator
expression, and multiple `ESum`s are collapsed:

> codegenExpression (ESum tyname0 expr0) = go [tyname0] expr0 where
>   go vars (ESum tyname expr) = go (tyname:vars) expr
>   go vars e = "pulp.lpSum(" ++ codegenExpression e ++ " " ++ go' (reverse vars) ++ ")"
>   go' [] = ""
>   go' (Typed name (ParamCustom ty):vs) =
>     let code = "for " ++ name ++ " in " ++ ty
>     in if null vs then code else code ++ " " ++ go' vs

I'm making some assumptions about how variables and types are
represented in Python:

1. I assume all names are the valid in Python, eg:

   **abstract:** `EMul 3 (EIndex "A", ["i"])`

   **code:** `3 * A[i]`

2. I assume user-defined types correspond to Python iterators, eg:

   **abstract:** `ESum (Typed "x" (ParamCustom "X")) expr`

   **code:** `pulp.lpSum(expr for x in X)`.

These aren't checked.  Assumption (1) could be handled by restricting
the characters in names (eg, to alphanumeric only).  Assumption (2)
would be handled if I were to implement the full abstract syntax, as
generated code would be put in a function which takes all the
parameter variables as arguments, and which creates the model
variables.  But this memo only implements expressions and constraints.

Generating code for constraints is nothing surprising, the only slight
complication is needing to make sure the indentation works out when
there are nested `CForall`s:

> codegenConstraint :: TypedConstraint -> String
> codegenConstraint = unlines . go where
>   go (CForall (Typed name (ParamCustom ty)) (Just (rname, rargs)) c) =
>     [ "for " ++ name ++ " in " ++ ty ++ ":"
>     , "    if not " ++ rname ++ "(" ++ strings rargs ++ "):"
>     , "        continue"
>     ] ++ indent (go c)
>   go (CForall (Typed name (ParamCustom ty)) _ c) =
>     [ "for " ++ name ++ " in " ++ ty ++ ":"
>     ] ++ indent (go c)
>   go (CCheck op expr1 expr2) =
>     let e1 = codegenExpression expr1
>         e2 = codegenExpression expr2
>     in ["problem += " ++ e1 ++ " " ++ cgOp op ++ " " ++ e2]
>
>   cgOp OEq = "=="
>   cgOp op = show op
>
>   indent = map ("    "++)

Example: code generation
------------------------

Here’s a little function to print out the generated code, or type
error, for all of our constraints from the running example:

> demoCodeGen :: IO ()
> demoCodeGen = for_ constraints $ \constraint -> do
>   case typecheckConstraint_  globals constraint of
>     Right c' -> do
>       putStrLn (" # " ++ show c')
>       putStrLn (codegenConstraint c')
>     Left err -> do
>       putStrLn err
>       putStrLn ""

Behold, again!

```
λ> demoCodeGen
 # forall param<TimeSlot> t; forall param<Role> r; sum{param<Person> p} A[t, p, r] = 1
for t in TimeSlot:
    for r in Role:
        problem += pulp.lpSum(A[t, p, r] for p in Person) == 1

 # forall param<TimeSlot> t; forall param<Person> p; sum{param<Role> r} A[t, p, r] <= 1
for t in TimeSlot:
    for p in Person:
        problem += pulp.lpSum(A[t, p, r] for r in Role) <= 1

 # forall param<Person> p; forall param<TimeSlot> t if is_leave(t, p); forall param<Role> r; A[t, p, r] = 0
for p in Person:
    for t in TimeSlot:
        if not is_leave(t, p):
            continue
        for r in Role:
            problem += A[t, p, r] == 0

 # forall param<Person> p; sum{param<TimeSlot> t} sum{param<Role> r} A[t, p, r] <= M
for p in Person:
    problem += pulp.lpSum(A[t, p, r] for t in TimeSlot for r in Role) <= M

 # forall param<TimeSlot> t; forall param<Person> p; forall param<Role> r; X[p] >= A[t, p, r]
for t in TimeSlot:
    for p in Person:
        for r in Role:
            problem += X[p] >= A[t, p, r]

 # forall param<Person> p; X[p] <= sum{param<TimeSlot> t} sum{param<Role> r} A[t, p, r]
for p in Person:
    problem += X[p] <= pulp.lpSum(A[t, p, r] for t in TimeSlot for r in Role)
```


What's missing?
---------------

We've come to the end of my little language for defining ILP problems,
but there is still more to be done if this were to become a
fully-fledged language people could use.  Here are some missing bits:

- A parser for the concrete syntax.
- More integer operations:
  - Integer ranges, in addition to user-defined set types, for
    `forall` and `sum`.
  - Arithmetic on integer indices.
  - Comparisons, in addition to predicate functions, in `forall`
    guards.
- The rest of the abstract syntax (along with typechecking and code
  generation): integer matrices, objective functions, and type and
  variable declarations.

For example, in the [GOV.UK support rota][], one of the constraints is
that someone can't be on support in two adjacent weeks.  With integer
ranges and arithmetic on integer indices, that could be expressed like
so:

```
forall t in [1, N), p; (sum{r} A[t, p, r]) + (sum{r} A[t - 1, p, r]) <= 1
```

There's also a small problem with the current abstract syntax: it's a
bit too flexible.  This is not a valid ILP expression:

```
sum{foo} (sum{bar} A[foo, bar] + sum{baz} B[foo, baz])
```

Only direct `sum` nesting is permitted.  There are two ways to solve
this.  One is to change the abstract syntax to preclude it, maybe
something like this:

> data Void
>
> data TaggedExpression tag a
>   = TESum !tag (SumExpression a)
>   | TEIndex Name [Name]
>   | TEVar Name
>   | TEConst Integer
>   | TEMul Integer (TaggedExpression tag a)
>   | TEAdd (TaggedExpression tag a) (TaggedExpression tag a)
>
> data SumExpression a
>   = SENest (TypedName a) (SumExpression a)
>   | SEBreak (TaggedExpression Void a)

A `TaggedExpression Void` can't contain any more `TESum` constructors,
because the `Void` type is uninhabited.  Another option is to add a
check, between parsing and typechecking, that there are no invalidly
nested `ESum`s.

[GOV.UK support rota]: scheduling-problems.html#modelling-the-gov.uk-support-rota-with-ilp
