---
title: Generating Typed Expressions
taxon: research-dejafucoco
tags: coco, code generation, haskell, programming
date: 2017-03-27
---

*[Representation & Evaluation of Typed Expressions](https://memo.barrucadu.co.uk/representation-and-evaluation-of-typed-expressions.html):
Episode II - Attack of the Terms*

This memo is about exhaustively generating schemas. Let's go!

> {-# LANGUAGE KindSignatures #-}
> {-# LANGUAGE ScopedTypeVariables #-}
> {-# LANGUAGE StandaloneDeriving #-}
>
> import Control.Monad (filterM)
> import Data.Function (on)
> import Data.IntMap (IntMap)
> import qualified Data.IntMap as M
> import Data.Maybe (maybeToList)
> import Data.Proxy (Proxy(..))
> import Data.Semigroup (Semigroup, (<>))
> import Data.Set (Set)
> import qualified Data.Set as S
> import Data.Typeable (Typeable, TypeRep, funResultTy, splitTyConApp, typeRep)
> import GHC.Exts (Any)
> import Unsafe.Coerce (unsafeCoerce)

Aside: Expression Size
----------------------

To concretely tie down what we're doing, we're going to generate expressions in *size*
order. Expression size here corresponds roughly to the number of nodes in the tree:

> sizeOf :: Exp m h -> Int
> sizeOf (Lit _ _) = 1
> sizeOf (Var _ _) = 1
> sizeOf (Bind _ b e) = 1 + sizeOf b + sizeOf e
> sizeOf (Let  _ b e) = 1 + sizeOf b + sizeOf e
> sizeOf (Ap   _ f e) =     sizeOf f + sizeOf e


Aside: Expression Order
-----------------------

In order to avoid duplicates, we're going to want sets of expressions. We're going to cheat a little
because we can't actually compare `BDynamic` values, so we'll just compare their types, and hope
that that plus the string representations in `Lit` will be enough to disambiguate.

> instance Eq BDynamic  where (==) = (==) `on` bdynTypeRep
> instance Ord BDynamic where compare = compare `on` bdynTypeRep
>
> deriving instance Eq  h => Eq  (Var h)
> deriving instance Ord h => Ord (Var h)
>
> deriving instance Eq  h => Eq  (Exp m h)
> deriving instance Ord h => Ord (Exp m h)


Mark 1: Generating Terms
------------------------

We're going to keep quite a simple interface for our schema generator, we shall have:

1. A type of generators, which is a map from size to generated schemas of that size.
2. A function to get all the schemas of a size.
3. A function to make a new generator from a collection of "primitive" schemas.
4. A function to generate a size, assuming all smaller sizes have been generated.

> -- | A generator of schemas, in size order.
> newtype Generator1 m = Generator1 { tiers1 :: IntMap (Set (Schema m)) }
>
> -- | Get all schemas of the given size, if generated.
> schemas1 :: Generator1 m -> Int -> Set (Schema m)
> schemas1 g i = M.findWithDefault (S.empty) i (tiers1 g)

**Creation**: to make a new generator, we'll just plug the provided schemas into the appropriate
tiers.

> -- | Create a new generator from a set of initial schemas.
> create1 :: [Schema m] -> Generator1 m
> create1 initial = Generator1 $ M.unionsWith S.union
>   [M.singleton (sizeOf s) (S.singleton s) | s <- initial]

**Generation**: now we see the benefit of all the smart `Maybe`-returning constructors: we can do
the incredibly naive thing of just trying all correctly-sized combinations of already-known
schemas. The ones which return a `Just` are good and shall be kept.

> -- | Generate schemas of the given size, assuming all smaller tiers have been generated.
> generate1 :: (Applicative m, Typeable m) => Int -> Generator1 m -> Generator1 m
> generate1 i g = Generator1 $ M.unionsWith S.union
>     [ tiers1 g
>     , M.singleton i aps
>     , M.singleton i binds
>     , M.singleton i lets
>     ]
>   where
>     -- sizeOf (ap f e) = 0 + sizeOf f + sizeOf e
>     aps = makeTerms 0 $ \terms candidates ->
>       [ new | f <- terms
>             , e <- candidates
>             , new <- maybeToList (ap f e)
>       ]
>     -- sizeOf (bind is b e) = 1 + sizeOf b + sizeOf e
>     binds = makeTerms 1 $ \terms candidates ->
>       [ new | b <- terms
>             , e <- candidates
>             , holeset <- powerset . map fst $ holes e
>             , new <- maybeToList (bind holeset b e)
>       ]
>     -- sizeOf (let_ is b e) = 1 + sizeOf b + sizeOf e
>     lets = makeTerms 1 $ \terms candidates ->
>       [ new | b <- terms
>             , e <- candidates
>             , holeset <- powerset . map fst $ holes e
>             , new <- maybeToList (let_ holeset b e)
>       ]
>
>     makeTerms n f = M.foldMapWithKey go (tiers1 g) where
>       go tier terms = S.fromList $
>         let candidates = schemas1 g (i - tier - n)
>         in f (S.toList terms) (S.toList candidates)
>
>     powerset = filterM (const [False,True])

Here's a small demo:

```
demo1 :: Generator1 IO
demo1 = create1
  [ hole $ typeRep (Proxy :: Proxy Int)
  , lit "0"    . toBDynamic $ (0 :: Int)
  , lit "1"    . toBDynamic $ (1 :: Int)
  , lit "+"    . toBDynamic $ ((+) :: Int -> Int -> Int)
  , lit "*"    . toBDynamic $ ((*) :: Int -> Int -> Int)
  , lit "pure" . toBDynamic $ (pure :: Int -> IO Int)
  ]

λ> let upto n = mapM_ print . S.toList $ schemas1 (foldl (flip generate1) demo1 [1..n]) n

λ> upto 1
*
+
0
1
pure
(_ :: Int)

λ> upto 2
(pure) (0)
(pure) (1)
(pure) ((_ :: Int))
(*) (0)
(*) (1)
(*) ((_ :: Int))
(+) (0)
(+) (1)
(+) ((_ :: Int))

λ> upto 3
let <*> in <0>
let <*> in <1>
let <*> in <(_ :: Int)>
let <+> in <0>
let <+> in <1>
let <+> in <(_ :: Int)>
let <0> in <0>
let <0> in <1>
let <0> in <(_ :: Int)>
let <0> in <(b0 :: Int)>
let <1> in <0>
let <1> in <1>
let <1> in <(_ :: Int)>
let <1> in <(b0 :: Int)>
let <pure> in <0>
let <pure> in <1>
let <pure> in <(_ :: Int)>
let <(_ :: Int)> in <0>
let <(_ :: Int)> in <1>
let <(_ :: Int)> in <(_ :: Int)>
let <(_ :: Int)> in <(b0 :: Int)>
let <*> in <*>
let <*> in <+>
let <+> in <*>
let <+> in <+>
let <0> in <*>
let <0> in <+>
let <1> in <*>
let <1> in <+>
let <pure> in <*>
let <pure> in <+>
let <(_ :: Int)> in <*>
let <(_ :: Int)> in <+>
let <*> in <pure>
let <+> in <pure>
let <0> in <pure>
let <1> in <pure>
let <pure> in <pure>
let <(_ :: Int)> in <pure>
((*) (0)) (0)
((*) (0)) (1)
((*) (0)) ((_ :: Int))
((*) (1)) (0)
((*) (1)) (1)
((*) (1)) ((_ :: Int))
((*) ((_ :: Int))) (0)
((*) ((_ :: Int))) (1)
((*) ((_ :: Int))) ((_ :: Int))
((+) (0)) (0)
((+) (0)) (1)
((+) (0)) ((_ :: Int))
((+) (1)) (0)
((+) (1)) (1)
((+) (1)) ((_ :: Int))
((+) ((_ :: Int))) (0)
((+) ((_ :: Int))) (1)
((+) ((_ :: Int))) ((_ :: Int))
```


Mark 2: Annotations & Pruning
-----------------------------

The current generator is nice and simple, but produces some uninteresting terms:

- Let-bindings where the body has no holes bound: `let <1> in <pure>`
- Let- and monadic- bindings where the binder is a hole: `let <(_ :: Int)> in <(b0 :: Int)>`

Note that we do want to keep monadic bindings where the body has no holes bound, as the monadic bind
may cause an interesting effect.

Furthermore, we may want to store additional information with the generated schemas, which we can
use to prune generation further, and record information for further use.

> -- | A generator of schemas with metadata, in size order.
> newtype Generator2 m ann = Generator2 { tiers2 :: IntMap (Set (Schema m, ann)) }

Generation is now a bit more involved:

> -- | Generate schemas of the given size, assuming all smaller tiers have been generated.
> generate2 :: (Applicative m, Typeable m, Semigroup ann, Ord ann)
>   => (ann -> ann -> Schema m -> Bool)
>   -- ^ A predicate to filter generated schemas.
>   -> Int
>   -> Generator2 m ann
>   -> Generator2 m ann
> generate2 annp i g = Generator2 $ M.unionsWith S.union
>     [ tiers2 g
>     , M.singleton i aps
>     , M.singleton i binds
>     , M.singleton i lets
>     ]
>   where
>     aps = makeTerms 0 $ \terms candidates ->
>       [ (new, fAnn <> eAnn) -- produce a new annotation by combining the old
>         | (f, fAnn) <- terms
>         , (e, eAnn) <- candidates
>         , new <- maybeToList (ap f e)
>         -- check the new expression and old annotations against the predicate
>         , annp fAnn eAnn new
>       ]
>
>     binds = makeTerms 1 $ \terms candidates ->
>       [ (new, bAnn <> eAnn) -- produce a new annotation by combining the old
>         | (b, bAnn) <- terms
>         -- don't allow a binder which is a hole
>         , case b of Var _ (Hole _) -> False; _ -> True
>         , (e, eAnn) <- candidates
>         , holeset <- powerset . map fst $ holes e
>         , new <- maybeToList (bind holeset b e)
>         -- check the new expression and old annotations against the predicate
>         , annp bAnn eAnn new
>       ]
>
>     lets = makeTerms 1 $ \terms candidates ->
>       [ (new, bAnn <> eAnn) -- produce a new annotation by combining the old
>         | (b, bAnn) <- terms
>         -- don't allow a binder which is a hole
>         , case b of Var _ (Hole _) -> False; _ -> True
>         , (e, eAnn) <- candidates
>         , holeset <- powerset . map fst $ holes e
>         -- don't allow an empty holeset
>         , not (null holeset)
>         , new <- maybeToList (let_ holeset b e)
>         -- check the new expression and old annotations against the predicate
>         , annp bAnn eAnn new
>       ]
>
>     makeTerms n f = M.foldMapWithKey go (tiers2 g) where
>       go tier terms = S.fromList $
>         let candidates = schemas2 g (i - tier - n)
>         in f (S.toList terms) (S.toList candidates)
>
>     powerset = filterM (const [False,True])

The `schemas` and `create` code are basically the same:

> -- | Get all schemas of the given size, if generated.
> schemas2 :: Generator2 m ann -> Int -> Set (Schema m, ann)
> schemas2 g i = M.findWithDefault (S.empty) i (tiers2 g)
>
> -- | Create a new generator from a set of initial schemas.
> create2 :: Ord ann => [(Schema m, ann)] -> Generator2 m ann
> create2 initial = Generator2 $ M.unionsWith S.union
>   [M.singleton (sizeOf e) (S.singleton s) | s@(e,_) <- initial]

Our demo now looks much better:

```
demo2 :: Generator2 IO ()
demo2 = create2 $ map (\e -> (e, ()))
  [ hole $ typeRep (Proxy :: Proxy Int)
  , lit "0"    . toBDynamic $ (0 :: Int)
  , lit "1"    . toBDynamic $ (1 :: Int)
  , lit "+"    . toBDynamic $ ((+) :: Int -> Int -> Int)
  , lit "*"    . toBDynamic $ ((*) :: Int -> Int -> Int)
  , lit "pure" . toBDynamic $ (pure :: Int -> IO Int)
  ]

λ> let upto n = mapM_ print . S.toList $ schemas2 (foldl (flip $ generate2 \_ _ _ -> True) demo2 [1..n]) n

λ> upto 1
((*,())
(+,())
(0,())
(1,())
(pure,())
((_ :: Int),())

λ> upto 2
((pure) (0),())
((pure) (1),())
((pure) ((_ :: Int)),())
((*) (0),())
((*) (1),())
((*) ((_ :: Int)),())
((+) (0),())
((+) (1),())
((+) ((_ :: Int)),())

λ> upto 3
(let <0> in <(b0 :: Int)>,())
(let <1> in <(b0 :: Int)>,())
(((*) (0)) (0),())
(((*) (0)) (1),())
(((*) (0)) ((_ :: Int)),())
(((*) (1)) (0),())
(((*) (1)) (1),())
(((*) (1)) ((_ :: Int)),())
(((*) ((_ :: Int))) (0),())
(((*) ((_ :: Int))) (1),())
(((*) ((_ :: Int))) ((_ :: Int)),())
(((+) (0)) (0),())
(((+) (0)) (1),())
(((+) (0)) ((_ :: Int)),())
(((+) (1)) (0),())
(((+) (1)) (1),())
(((+) (1)) ((_ :: Int)),())
(((+) ((_ :: Int))) (0),())
(((+) ((_ :: Int))) (1),())
(((+) ((_ :: Int))) ((_ :: Int)),())
```


Appendix: Expressions
---------------------

The Mark 3-ig expression types and smart constructors:

> data BDynamic = BDynamic { bdynTypeRep :: TypeRep, bdynAny :: Any }
>
> toBDynamic :: forall a. Typeable a => a -> BDynamic
> toBDynamic a = BDynamic (typeRep (Proxy :: Proxy a)) (unsafeCoerce a)
>
> data Exp (m :: * -> *) (h :: *)
>   = Lit String BDynamic
>   | Var TypeRep (Var h)
>   | Bind TypeRep (Exp m h) (Exp m h)
>   | Let  TypeRep (Exp m h) (Exp m h)
>   | Ap   TypeRep (Exp m h) (Exp m h)
>
> instance Show (Exp m h) where
>   show (Lit s _) = s
>   show (Var ty v) = "(" ++ show v ++ " :: " ++ show ty ++ ")"
>   show (Bind _ b e) = "bind <" ++ show b ++ "> in <" ++ show e ++ ">"
>   show (Let  _ b e) = "let <" ++ show b ++ "> in <" ++ show e ++ ">"
>   show (Ap   _ f e) = "(" ++ show f ++ ") (" ++ show e ++ ")"
>
> data Var h
>   = Hole  h
>   | Named String
>   | Bound Int
>
> instance Show (Var h) where
>   show (Hole  _) = "_"
>   show (Named s) = s
>   show (Bound i) = 'b' : show i
>
> type Schema m = Exp m ()
>
> data Ignore = Ignore deriving (Bounded, Enum, Eq, Ord, Read, Show)
>
> typeOf :: Exp m h -> TypeRep
> typeOf (Lit  _ dyn)  = bdynTypeRep dyn
> typeOf (Var  ty _)   = ty
> typeOf (Bind ty _ _) = ty
> typeOf (Let  ty _ _) = ty
> typeOf (Ap   ty _ _) = ty
>
> lit :: String -> BDynamic -> Exp m h
> lit = Lit
>
> hole :: TypeRep -> Schema m
> hole ty = Var ty (Hole ())
>
> let_ :: [Int] -> Schema m -> Schema m -> Maybe (Schema m)
> let_ is b e0 = Let (typeOf e0) b <$> letOrBind is (typeOf b) e0
>
> bind :: forall m. Typeable m => [Int] -> Schema m -> Schema m -> Maybe (Schema m)
> bind is b e0 = case (splitTyConApp (typeOf b), splitTyConApp (typeOf e0)) of
>     ((btyCon, btyArgs), (etyCon, etyArgs))
>       | btyCon == mtyCon && btyCon == etyCon && not (null btyArgs) && not (null etyArgs) && mtyArgs == init btyArgs && init btyArgs == init etyArgs
>         -> Bind (typeOf e0) b <$> letOrBind is (last btyArgs) e0
>     _ -> Nothing
>   where
>     (mtyCon, mtyArgs) = splitTyConApp (typeRep (Proxy :: Proxy m))
>
> ap :: forall m h. (Applicative m, Typeable m) => Exp m h -> Exp m h -> Maybe (Exp m h)
> ap f e = case (splitTyConApp (typeOf f), splitTyConApp (typeOf e)) of
>     ((_, [fargTy,fresTy]), (etyCon, etyArgs))
>       | fargTy == ignoreTy && etyCon == mtyCon && not (null etyArgs) && mtyArgs == init etyArgs -> Just (Ap fresTy f e)
>       | otherwise -> (\ty -> Ap ty f e) <$> typeOf f `funResultTy` typeOf e
>     _ -> Nothing
>   where
>     ignoreTy = typeRep (Proxy :: Proxy (m Ignore))
>     (mtyCon, mtyArgs) = splitTyConApp (typeRep (Proxy :: Proxy m))
>
> letOrBind :: [Int] -> TypeRep -> Exp m h -> Maybe (Exp m h)
> letOrBind is boundTy e0 = fst <$> go 0 0 e0 where
>   go n i (Var ty (Hole h))
>     | i `elem` is = if boundTy == ty then Just (Var ty (Bound n), i + 1) else Nothing
>     | otherwise   = Just (Var ty (Hole h), i + 1)
>   go n i (Bind ty b e) = do
>     (b', i')  <- go n     i  b
>     (e', i'') <- go (n+1) i' e
>     Just (Bind ty b' e', i'')
>   go n i (Let ty b e) = do
>     (b', i')  <- go n     i  b
>     (e', i'') <- go (n+1) i' e
>     Just (Let ty b' e', i'')
>   go n i (Ap ty f e) = do
>     (f', i')  <- go n i  f
>     (e', i'') <- go n i' e
>     Just (Ap ty f' e', i'')
>   go _ i e = Just (e, i)
>
> holes :: Schema m -> [(Int, TypeRep)]
> holes = fst . go 0 where
>   go i (Var ty (Hole _)) = ([(i, ty)], i + 1)
>   go i (Let _ b e) =
>     let (bhs, i')  = go i  b
>         (ehs, i'') = go i' e
>     in (bhs ++ ehs, i'')
>   go i (Ap _ f e) =
>     let (fhs, i')  = go i  f
>         (ehs, i'') = go i' e
>     in (fhs ++ ehs, i'')
>   go i _ = ([], i)
