---
title: The CSS Cascade Algorithm
tags: haskell, programming, webdev
date: 2019-11-02
---

I've never really been clear on how CSS handles conflict
resolution---how it determines what happens if two rules match the
same element---so I finally sat down and read the MDN docs on
[specificity][] and [cascading][].  This memo is a Literate Haskell
file implementing the cascade algorithm.  This memo doesn't implement
[conditional rules][] (eg, `@media` queries) or [inheritance][], or
even validate the properties and values.

[specificity]: https://developer.mozilla.org/en-US/docs/Web/CSS/Specificity
[cascading]: https://developer.mozilla.org/en-US/docs/Web/CSS/Cascade
[conditional rules]: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Conditional_Rules
[inheritance]: https://developer.mozilla.org/en-US/docs/Web/CSS/Inheritance

> import Control.Arrow (second)
> import Data.Char (isSpace)
> import Data.List (dropWhile, dropWhileEnd, inits, last, partition)
> import Numeric.Natural
>
> import qualified Data.List.NonEmpty as NE
> import qualified Data.Map as M


What is a CSS rule?
-------------------

A miserable little pile of properties.

A CSS rule consists of:

1. A *selector*, which determines what the rule applies to.
2. A list of *property / value* pairs, which determine its effect.

Some attributes are special, like `background`, `border`, or `margin`,
in that they're a shorthand to specify multiple attributes in one go.
For example, these rules are all equivalent:

```css
div {
  margin: 1em 2em;
}

div {
  margin: 1em 2em 1em 2em;
}

div {
  margin-top:    1em;
  margin-right:  2em;
  margin-bottom: 1em;
  margin-left:   2em;
}
```

I don't know what the proper terms for these different forms are, so
I'll call them *shorthand properties* and *canonical properties*.
`margin` is a shorthand property.  `margin-top` is a canonical
property.  Shorthand properties are a form of syntactic sugar.

Rules with multiple properties are also a form of syntactic sugar.
This rule:

```css
div {
  margin-top:    1em;
  margin-right:  2em;
  margin-bottom: 1em;
  margin-left:   2em;
}
```

Is equivalent to these four rules:

```css
div {
  margin-top:    1em;
}
div {
  margin-right:  2em;
}
div {
  margin-bottom: 1em;
}
div {
  margin-left:   2em;
}
```

Obviously you would never write CSS like that, *but* it is going to
simplify our code.  So the rest of the memo will assume all rules have
exactly one property, and that property is canonical.

So, what is a rule?  It's a selector, a property name, a property
value, and an importance flag:

> -- | A CSS rule.
> data Rule = Rule
>   { rSelector :: Selector
>   -- ^ What the rule matches.
>   , rBody :: (PropName, PropValue)
>   -- ^ The effect of the rule.
>   , rIsImportant :: Bool
>   -- ^ Does the rule have an @!important@ annotation?
>   } deriving Show

[Selectors][] are a bit tricky, so to simplify the implementation I'm
skipping some of the combinators:

[Selectors]: https://developer.mozilla.org/en-US/docs/Web/CSS/Reference#Selectors

> -- | CSS selectors, but to simplify the implementation I'm omitting
> -- the list combinator (@A, B@), sibling combinators (@A + B@ and
> -- @A ~ B@), and column combinator (@A || B@).
> data Selector
>   = SUniversal
>   -- ^ @*@ - matches everything.
>   | SElement ElName
>   -- ^ @elementname@ - matches that element.
>   | SClass AttrValue
>   -- ^ @.classname@ - matches elements with that class.
>   | SId AttrValue
>   -- ^ @#idname@ - matches elements with that ID.
>   | SAttribute AttrName AttrValue
>   -- ^ @[name=value]@ - matches elements with that attribute.
>   | SChild Selector Selector
>   -- ^ @A > B@ - matches elements which match @B@, if their parent
>   -- matches @A@.
>   | SDescendent Selector Selector
>   -- ^ @A B@ - matches elements which match @B@, if at least one of
>   -- their ancestors matches @A@.
>   deriving Show

An element has a name and a bunch of attributes:

> -- | An HTML element.
> data Element = Element
>   { eName :: ElName
>   -- ^ The name of the element.
>   , eAttributes :: M.Map AttrName AttrValue
>   -- ^ Its attributes.
>   } deriving Show

And finally we have some `String` newtypes to avoid confusion:

> newtype ElName    = ElName    String deriving (Eq, Ord, Show)
> newtype AttrName  = AttrName  String deriving (Eq, Ord, Show)
> newtype AttrValue = AttrValue String deriving (Eq, Ord, Show)
> newtype PropName  = PropName  String deriving (Eq, Ord, Show)
> newtype PropValue = PropValue String deriving (Eq, Ord, Show)

Given a path through the document tree---a nonempty sequence of
elements---we can check if a selector matches:

> -- | Check if a selector matches an element, given as a path through
> -- the HTML tree.  To simplify the implementation this doesn't match
> -- pseudo-selectors.
> --
> -- The implementation of the descendent selector is not very
> -- efficient.
> match :: NE.NonEmpty Element -> Selector -> Bool
> match path sel0 = match' (NE.init path) (NE.last path) sel0 where
>   match' _ _ SUniversal = True
>   match' _ el (SElement n) = eName el == n
>   match' _ el (SClass   v) = checkAttr el (AttrName "class") v
>   match' _ el (SId      v) = checkAttr el (AttrName "id") v
>   match' _ el (SAttribute  k v) = checkAttr el k v
>   match' [] _ (SChild      _ _) = False
>   match' [] _ (SDescendent _ _) = False
>   match' prefix el (SChild selA selB) =
>     let parentPrefix = init prefix
>         parent = last prefix
>     in match' prefix el selB && match' parentPrefix parent selA
>   match' prefix el (SDescendent selA selB) =
>     match' prefix el selB &&
>     any (\(parentPrefix, parent) -> match' parentPrefix parent selA) (parents prefix)
>
>   parents = map (\els -> (init els, last els)) . tail . inits
>
>   checkAttr el k v = M.lookup k (eAttributes el) == Just v


The Cascade
-----------

"The cascade" is the algorithm which resolves rule conflicts.  Each
page is made up of a few different stylesheets: the user-agent
stylesheet built into the browser, the user's personal stylesheet, and
the author's stylesheet.  There are also inline styles defined on HTML
elements themselves.  Rules are applied in this order:

1. Non-`!important` rules from the user-agent stylesheet
2. Non-`!important` rules from the user's stylesheet
3. Non-`!important` rules from the author's stylesheet
4. Animation rules
5. `!important` rules from the author's stylesheet
6. `!important` rules from the user's stylesheet
7. `!important` rules from the user-agent stylesheet
8. Transition rules

Inline styles are effectively `!important` rules applied between steps
4 and 5.  If two rules conflict, the one with the highest
*specificity* (see next section) wins.

> -- | The cascade algorithm.
> --
> -- The implementation of multiple stylesheets is not very efficient.
> cascade
>   :: [Rule] -- ^ User-agent stylesheet
>   -> [Rule] -- ^ User's stylesheet
>   -> [Rule] -- ^ Author's stylesheet
>   -> NE.NonEmpty Element
>   -> M.Map PropName PropValue
> cascade userAgent user author el =
>     fmap snd .
>     overrideProperties important .
>     overrideProperties normal $ inlineStyle (NE.last el)
>   where
>     normal = prepare $
>       filter (not . rIsImportant) userAgent ++
>       filter (not . rIsImportant) user ++
>       filter (not . rIsImportant) author
>
>     important = prepare $
>       filter rIsImportant author ++
>       filter rIsImportant user ++
>       filter rIsImportant userAgent
>
>     prepare rules =
>       [ (specificity sel important (Just position), body)
>       | (position, Rule { rSelector = sel, rBody = body, rIsImportant = important }) <- zip [0..] rules
>       , match el sel
>       ]
>
>     overrideProperties = flip (foldr override) where
>       override (spec, (pname, pvalue)) props = case M.lookup pname props of
>         Just (spec', _) | spec <= spec' -> props
>         _ -> M.insert pname (spec, pvalue) props

A bit less grand than the name implies, to me.


Specificity
-----------

Specificity determines how well a rule matches an element.  The MDN
docs are... okay.  [This diagram][] is much better.

[This diagram]: https://specifishity.com/

Specificity can be thought of as a total lexicographical ordering on
5-tuples:

> -- | The specificity of a rule.
> data Specificity = Specificity
>   { sIsImportant :: Bool
>   -- ^ Whether the rule is important or not.  Strictly speaking this
>   -- isn't really necessary, because the cascade does important
>   -- rules after non-important rules.
>   , sNumIdSelectors :: Natural
>   -- ^ The number of ID selectors.
>   , sNumAttrSelectors :: Natural
>   -- ^ The number of class selectors, attribute selectors, and
>   -- pseudo-classes.
>   , sNumElSelectors :: Natural
>   -- ^ The number of element selectors and pseudo-elements.
>   , sSourcePosition :: Maybe Natural
>   -- ^ The position in the stylesheet, with the first-defined rule
>   -- having position zero.  This is a @Maybe@ because inline styles
>   -- don't have a source position.
>   } deriving (Eq, Ord, Show)

The default derived ordering compares the fields in order, which is
what we want.

An inline rule doesn't really have a specificity according to the MDN
docs (as I read it): inline rules trump everything non-`!important`,
and are trumped by everything `!important`.  But, rather than have
them be a special case, they can be given a specificity:

> -- | The specificity of an inline rule.
> inlineSpecificity :: Specificity
> inlineSpecificity = Specificity
>   { sIsImportant      = True
>   , sNumIdSelectors   = 0
>   , sNumAttrSelectors = 0
>   , sNumElSelectors   = 0
>   , sSourcePosition   = Nothing
>   }

Getting the actual inline rules involves a bit of string-wrangling:

> inlineStyle :: Element -> M.Map PropName (Specificity, PropValue)
> inlineStyle el = case M.lookup (AttrName "style") (eAttributes el) of
>     Just (AttrValue style) -> M.fromList
>       [ (PropName (trim k), (inlineSpecificity, PropValue (trim v)))
>       | prop <- splitOn (==';') style
>       , let (k, (':':v)) = break (==':') prop
>       ]
>     Nothing -> M.empty
>   where
>     splitOn p s = case dropWhile p s of
>       [] -> []
>       s' -> let (w, s'') = break p s' in w : splitOn p s''
>
>     trim = dropWhile isSpace . dropWhileEnd isSpace

Using that helpful diagram, we can compute the specificity of a
selector, if we know whether its rule is important and its source
position:

> -- | Compute the specificity of a selector.
> specificity :: Selector -> Bool -> Maybe Natural -> Specificity
> specificity sel0 important position = go spec0 sel0 where
>   go spec SUniversal = spec
>   go spec (SElement     _) = spec { sNumElSelectors   = sNumElSelectors   spec + 1 }
>   go spec (SClass       _) = spec { sNumAttrSelectors = sNumAttrSelectors spec + 1 }
>   go spec (SId          _) = spec { sNumIdSelectors   = sNumIdSelectors   spec + 1 }
>   go spec (SAttribute _ _) = spec { sNumAttrSelectors = sNumAttrSelectors spec + 1 }
>   go spec (SChild selA selB) =
>     let spec' = go spec selA
>     in go spec' selB
>   go spec (SDescendent selA selB) =
>     let spec' = go spec selA
>     in go spec' selB
>
>   spec0 = Specificity
>     { sIsImportant      = important
>     , sNumIdSelectors   = 0
>     , sNumAttrSelectors = 0
>     , sNumElSelectors   = 0
>     , sSourcePosition   = position
>     }

An interesting property of specificity, which I'm sure has confused me
in the past, is that proximity doesn't matter.  In this HTML:

```html
<div>
  <p><span>Hello world</span></p>
</div>
```

All of these rules match the `span`, and are all equally specific
(ignoring source position):

```css
div span { color: red;   }
p span   { color: blue;  }
p > span { color: green; }
```

And, as the universal selector doesn't affect specificity, these rules
are all equally specific (ignoring source position):

```css
span     { color: aqua;   }
* span   { color: linen;  }
* * span { color: violet; }
```

In both sets of rules, which one wins is determined by source
position, nothing more.  Now I see why frontend devs tend to use a lot
of class and ID selectors, and not so many child or descendent
selectors.


Trying it out
-------------

Now is the time to try out some CSS rules, and to check if Firefox
agrees with me.

Here is an HTML document:

```html
<html>
  <head>
    <style>
      body { font-size: 16px; }
      h1 { font-weight: bold; }
      body > * { font-weight: normal; }
      div { color: red; }
      div span { color: green; }
      div div p span { color: black; }
      .inner { font-weight: bold !important; }
      .inner { font-weight: normal; }
      div div { background-color: black; }
      .inner { background-color: white; }
    </style>
  </head>
  <body>
    <h1>Hello, world!</h1>
    <div class="outer">
      <div class="inner">
        <p>
          <span>Line of text</span>
        </p>
      </div>
    </div>
  </body>
</html>
```

The style rules correspond to this Haskell:

> authorRules :: [Rule]
> authorRules =
>     [ r (SElement (ElName "body")) "font-size" "16px" False
>     , r (SElement (ElName "h1"))  "font-weight" "bold" False
>     , r (SChild (SElement (ElName "body")) SUniversal) "font-weight" "normal" False
>     , r (SElement (ElName "div")) "color" "red" False
>     , r (SDescendent (SElement (ElName "div")) (SElement (ElName "span"))) "color" "green" False
>     , r (SDescendent (SDescendent (SDescendent (SElement (ElName "div")) (SElement (ElName "div"))) (SElement (ElName "p"))) (SElement (ElName "span"))) "color" "black" False
>     , r (SClass (AttrValue "inner")) "font-weight" "bold" True
>     , r (SClass (AttrValue "inner")) "font-weight" "normal" False
>     , r (SDescendent (SElement (ElName "div")) (SElement (ElName "div"))) "background-color" "black" False
>     , r (SClass (AttrValue "inner")) "background-color" "white" False
>     ]
>   where
>     r sel k v = Rule sel (PropName k, PropValue v)

And the relevant bit of Firefox's user-agent stylesheet is:

> userAgentRules :: [Rule]
> userAgentRules =
>   [ r (SElement (ElName "h1")) "font-size" "2em" False
>   ]
>   where
>     r sel k v = Rule sel (PropName k, PropValue v)

I don't have a user stylesheet:

> userRules :: [Rule]
> userRules = []

A bit verbose...

We can now get the computed style for every element:

> computedStyles :: [M.Map PropName PropValue]
> computedStyles = map (cascade userAgentRules userRules authorRules) paths where
>   paths = map NE.fromList
>     [ [e "body" []]
>     , [e "body" [], e "h1" []]
>     , [e "body" [], e "div" [("class", "outer")]]
>     , [e "body" [], e "div" [("class", "outer")], e "div" [("class", "inner")]]
>     , [e "body" [], e "div" [("class", "outer")], e "div" [("class", "inner")], e "p" []]
>     , [e "body" [], e "div" [("class", "outer")], e "div" [("class", "inner")], e "p" [], e "span" []]
>     ]
>
>   e n kvs = Element (ElName n) (M.fromList [(AttrName k, AttrValue v) | (k, v) <- kvs])

Which gives these styles:

```html
<html>
  <body style="font-size: 16px">
    <h1 style="font-size: 2em; font-weight: normal">Hello, world!</h1>
    <div style="color: red; font-weight: normal">
      <div style="background-color: white; color: red; font-weight: bold">
        <p>
          <span style="color: black">Line of text</span>
        </p>
      </div>
    </div>
  </body>
</html>
```

Which Firefox agrees with!
