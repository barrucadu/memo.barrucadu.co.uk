---
title: Mixing and Matching Variables
taxon: research-dejafucoco
tags: coco, haskell, programming
date: 2017-04-04
---

Thanks to the two prior memos in this series, we can generate *schemas* and produce a set of *terms*
from a schema, and we can evaluate these terms and store the results of so doing, so that we can
later compare schemas.

The problem is: given two terms (from different schemas) and their results, how do we compare them?
For instance, consider we have two terms:

```
term1 = f (x :: Int) (y :: Int)  (z :: Bool)
term2 = g (x :: Int) (y :: Bool) (z :: Bool)
```

Which fulfil the property that when the `z` in `term1` is equal to the `y` in `term2`, the terms
have the same result. Each term introduces its own environment variable namespace, so what we want
is a projection into a shared namespace, in which we can reason about the equalities we desire.

We can simplify the problem a little by not changing the number of unique variables inside a term,
only restricting ourselves to identifying (or not) variables across terms. Here are some possible
projections of those terms:

```
f x1 y1 z1 =?= g x1 y2 z2
f x1 y1 z1 =?= g x2 z1 z2
f x1 y1 z1 =?= g x2 y2 z1
f x1 y1 z1 =?= g x2 y1 z2
and so on
```

So we want to produce a *set* of all such type-correct projections.

This memo is a literate Haskell file (though confusingly I mix source with examples, which are NOT
syntax-highlighted), and we'll need this:

> {-# LANGUAGE LambdaCase #-}


Aside: The `These` type
-----------------------

I recently read a blog post entitled [These, Align, and Crosswalk](http://teh.id.au/posts/2017/03/29/these-align-crosswalk)
about safely zipping (or merging) data structures. The core of the blog post is the `These` type,
defined as so:

> -- | The @These@ type is like 'Either', but also has the case for when we have both values.
> data These a b
>   = This a
>   | That b
>   | These a b
>   deriving Show

I don't *think* I need anything else from the [these](https://hackage.haskell.org/package/these)
package, so I'll just inline that definition there. It turns out to be exactly the thing we need!


Finding All Renamings
---------------------

Firstly, we need a representation of terms, from which we can extract variables. We don't actually
need anything other than variable names and types, so let's just go for that:

> type Name = String
> type Type = Int
> type Term = [(Name, Type)]

Our challenge is to find two functions:

```
projections :: Term -> Term -> [[(These Name Name, Type)]]
renaming    :: (Type -> Name) -> [(These Name Name, Type)] -> ([(Name, Name)], [(Name, Name)])
```

Where a `These String String` value represents a type-correct renaming of variables:

- `This s` means a variable from the left term is kept distinct from all variables in the right
  term.
- `That s` means a variable from the right term is kept distinct from all variables in the left
  term.
- `These s1 s2` means a variable from the left term is identified with a variable from the right
  term.

> -- | Find all type-correct ways of associating variables.
> projections :: Term -> Term -> [[(These Name Name, Type)]]
> projections t1 [] = [[(This v, ty) | (v, ty) <- t1]]
> projections [] t2 = [[(That v, ty) | (v, ty) <- t2]]
> projections ((vL, tyL):t1) t2 =
>  concat [map ((These vL vR, tyL) :) (projections t1 (filter (/=x) t2)) | x@(vR, tyR) <- t2, tyL == tyR]
>  ++ map ((This vL, tyL) :) (projections t1 t2)

By appending the `concat` to the `map` we can instead generate in order from most general (most
`This`/`That` usage) to least general (most `These` usage).

Now that we have projections, we can produce consistent renamings:

> -- | Given a projection into a common namespace, produce a consistent variable renaming. Variables
> -- of the same type, after the first, will have a number appended starting from 1.
> renaming :: (Type -> Name) -> [(These Name Name, Type)] -> ([(Name, Name)], [(Name, Name)])
> renaming varf = go [] ([], []) where
>   go e x ((these, ty):rest) =
>     let name = varf ty
>     in rename e x name (maybe 0 (+1) $ lookup name e) these rest
>   go e x [] = x
>
>   rename e ~(l, r) name n = let name' = if n == 0 then name else name ++ show n in \case
>     This  vL    -> go ((name, n):e) ((vL, name'):l,             r)
>     That     vR -> go ((name, n):e) (l,             (vR, name'):r)
>     These vL vR -> go ((name, n):e) ((vL, name'):l, (vR, name'):r)

The two steps can be combined:

> -- | Find all consistent renamings of a pair of terms.
> renamings :: (Type -> Name) -> Term -> Term -> [([(Name, Name)], [(Name, Name)])]
> renamings varf t1 t2 = map (renaming varf) (projections t1 t2)

My only regret is that I found no use for the fancier functions in the
[these](https://hackage.haskell.org/package/these) package.
