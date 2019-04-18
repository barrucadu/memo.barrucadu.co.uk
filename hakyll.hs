{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}

module Main where

import           Control.Monad          (mplus)
import           Data.Char              (toLower)
import           Data.List              (isPrefixOf, sortBy, stripPrefix)
import           Data.Maybe             (catMaybes, fromMaybe, isJust)
import           Data.Monoid            ((<>))
import           Data.Ord               (Down(..), comparing)
import           Data.Time.Format       (defaultTimeLocale)
import           Data.Witherable        (filterA)
import           Hakyll
import           System.IO              (hClose, hPutStrLn)
import           System.IO.Temp         (withSystemTempFile)
import           System.Process         (readProcess)
import           Text.Pandoc.Definition (Block(..), Format(..), Inline(..))
import           Text.Pandoc.Generic    (queryWith)
import           Text.Pandoc.SideNote   (usingSideNotes)
import           Text.Pandoc.Walk       (walkM)

main :: IO ()
main = hakyllWith defaultConfiguration $ do
  -- Templates
  match "templates/*" $
    compile templateCompiler

  -- Copy static files
  match "static/**" $ do
    route $ dropPat "static/"
    compile copyFileCompiler

  -- Compile css files
  match "css/*" $ do
    route $ dropPat "css/"
    compile compressCssCompiler

  -- MathJaX
  match "MathJax/**" $ do
    route idRoute
    compile copyFileCompiler

  -- Tags
  let mkTags = buildTagsWithExtra "memos/*" . fromCapture
  tags <- mkTags "tag/*.html"
  tagsRules tags $ \tag ->
    memoList (Just tag) tags
  feedTags <- mkTags "tag/*.xml"
  tagsRules feedTags $ \tag ->
    memoFeed (Just tag)

  -- Render memos
  match "memos/*" $ do
    route $
      setExtension ".html" `composeRoutes`
      dropPat      "memos/"
    compile (memoCompiler tags)

  -- Render index page
  create ["index.html"] $
    memoList Nothing tags "memos/*"
  create ["atom.xml"] $
    memoFeed Nothing "memos/*"


-------------------------------------------------------------------------------
-- * Rendering memos

-- | Render a single memo
memoCompiler :: Tags -> Compiler (Item String)
memoCompiler tags = do
  toc <- extractTOC
  myPandoc
    >>= saveSnapshot "content"
    >>= loadAndApplyTemplate "templates/memo.html"    (memoCtx toc tags)
    >>= loadAndApplyTemplate "templates/return.html"  defaultContext
    >>= loadAndApplyTemplate "templates/wrapper.html" defaultContext
    >>= relativizeUrls

-- | Render a memo listing page
memoList :: Maybe String -> Tags -> Pattern -> Rules ()
memoList tag tags pat = do
  route idRoute
  compile $ do
    entries <- sortMemos =<< loadAll pat
    let ctx = maybe id (\t -> (constField "tag" t <>)) tag $
              constField "title" (titleFor tag) <>
              listField "memos" (memoCtx [] tags) (return entries) <>
              defaultContext
    makeItem ""
      >>= loadAndApplyTemplate "templates/memo-list.html" ctx
      >>= (if isJust tag then loadAndApplyTemplate "templates/return.html" ctx else pure)
      >>= loadAndApplyTemplate "templates/wrapper.html"   ctx
      >>= relativizeUrls

memoCtx :: [(String, String)] -> Tags -> Context String
memoCtx toc tags = mconcat
  [ listField "toc" (field "anchor" (\(Item _ (a,_)) -> pure a) <> field "text" (\(Item _ (_,t)) -> pure t) <> missingField) (pure (map (Item "") toc))
  , boolField "has_toc" (const (not (null toc)))
  , dateField "isodate" "%Y-%m-%d"
  , dateField "ppdate"  "%B %e, %Y"
  , tagsField "tags"    tags
  , defaultContext
  ]


-------------------------------------------------------------------------------
-- * Rendering feeds

-- | Render a memo atom feed
memoFeed :: Maybe String -> Pattern -> Rules ()
memoFeed tag pat = do
  route idRoute
  compile $ loadAllSnapshots pat "content"
    >>= recentFirst
    >>= fmap (take 10) . filterA (fmap not . isPersonal)
    >>= renderAtom (feedCfg (titleFor tag)) feedCtx

feedCfg :: String -> FeedConfiguration
feedCfg title = FeedConfiguration
  { feedTitle       = title
  , feedDescription = ""
  , feedAuthorName  = "Michael Walker"
  , feedAuthorEmail = "mike@barrucadu.co.uk"
  , feedRoot        = "https://memo.barrucadu.co.uk"
  }

feedCtx :: Context String
feedCtx = mconcat
  [ bodyField "description"
  , defaultContext
  ]

-------------------------------------------------------------------------------

-- | * Use pygments/pygmentize for syntax highlighting
--   * Render footnotes as sidenotes
--   * Process special-cased code blocks (see 'codeProcessors')
myPandoc :: Compiler (Item String)
myPandoc = pandocCompilerWithTransformM ropts wopts pandoc where
  pandoc = fmap usingSideNotes . unsafeCompiler . walkM render
  ropts = defaultHakyllReaderOptions
  wopts = defaultHakyllWriterOptions

  render (CodeBlock opts code) = RawBlock (Format "html") <$> case opts of
    (_, lang:_, _) ->
      -- For some reason Haskell source in .lhs files is reported as
      -- "sourcecode". There may be other edge cases, but as I never
      -- want to highlight anything other than Haskell that is fine.
      let lang' = map toLower lang
      in if lang' == "sourcecode"
         then transformCode "haskell" code
         else transformCode lang' code
    _ -> pure $ "<pre class=\"code\">" ++ escapeHtml code ++ "</pre>"
  render x = pure x

  transformCode lang code = process codeProcessors where
    process ((prefix, def, f):rest) = case stripPrefix prefix lang of
      Just suff -> f (getArg def suff) code
      Nothing -> process rest
    process [] = do
      html <- readProcess "pygmentize" ["-l", lang,  "-f", "html", "-O", "nowrap"] code
      pure $ "<pre class=\"code\">" ++ html ++ "</pre>"

    getArg _ (':':arg) = arg
    getArg def _ = def


-------------------------------------------------------------------------------
-- * Code processors

-- | Special-cased code blocks, in the format @[(langauge, default
-- arg, processor func)]@.  Called on code blocks where the langauge
-- matches, argument is given in the format \"language:argument\".
codeProcessors :: [(String, String, String -> String -> IO String)]
codeProcessors =
  [ ("graphviz", "dot", graphvizToHtml)
  , ("asciiart", "", \_ art -> pure ("<pre class=\"asciiart\">" ++ art ++ "</pre>"))
  , ("raw", "", const pure)
  ]

-- | Render graphviz code.
graphvizToHtml :: String -> String -> IO String
graphvizToHtml cmd src = withSystemTempFile "memo-graphviz-" $ \tmpFile hFile -> do
  hPutStrLn hFile src
  hClose hFile
  html <- dropUntil "<svg" <$> readProcess cmd ["-Tsvg", tmpFile] ""
  pure $ "<figure>" ++ html ++ "</figure>"


-------------------------------------------------------------------------------
-- * Memo utilities

-- | Extract 2nd-level headings.
extractTOC :: Compiler [(String, String)]
extractTOC = do
    body <- getResourceBody
    doc <- itemBody <$> readPandoc body
    pure $ queryWith extractH doc
  where
    extractH (Header 2 (htmlid, _, _) inlines) = [(htmlid, queryWith extractT inlines)]
    extractH _ = []

    extractT (Str s) = s
    extractT Space = " "
    extractT _ = ""

-- | Add "important" and "deprecated" tags if those fields are
-- present.
buildTagsWithExtra :: MonadMetadata m => Pattern -> (String -> Identifier) -> m Tags
buildTagsWithExtra = buildTagsWith $ \identifier -> do
  metadata <- getMetadata identifier
  let fieldValue fld = fromMaybe [] $ lookupStringList fld metadata `mplus` (map (lowerCase . trim) . splitAll "," <$> lookupString fld metadata)
  let hasField   fld = isJust (lookupString fld metadata)
  pure $
    ["important"  | hasField "important"] ++
    ["deprecated" | hasField "deprecated_by"] ++
    fieldValue "audience" ++
    fieldValue "tags"

-- | Sort memos by date (descending), with important memos at the top,
-- and removing deprecated memos.
sortMemos :: MonadMetadata m => [Item a] -> m [Item a]
sortMemos = sortByA info where
  sortByA f xs =
    fmap (map fst . sortBy (comparing snd) . catMaybes) $
    traverse (\x -> fmap (x,) <$> f x) xs

  info item = do
    let identifier = itemIdentifier item
    metadata <- getMetadata identifier
    let isDeprecated = isJust (lookupString "deprecated_by" metadata)
    let isImportant  = isJust (lookupString "important" metadata)
    date <- getItemUTC defaultTimeLocale identifier
    pure (if isDeprecated then Nothing else Just (Down isImportant, Down date))

-- | Check if a memo has a "Personal" target audience.
isPersonal :: MonadMetadata m => Item a -> m Bool
isPersonal item = do
  metadata <- getMetadata (itemIdentifier item)
  pure (lookupString "audience" metadata == Just "Personal")

-- | Title for a memo listing or feed, with optional tag.
titleFor :: Maybe String -> String
titleFor (Just tag) = "barrucadu's memos - tagged '" ++ tag ++ "'"
titleFor Nothing    = "barrucadu's memos"


-------------------------------------------------------------------------------
-- * General utilities

-- | Remove some portion of the route
dropPat :: String -> Routes
dropPat pat = gsubRoute pat (const "")

-- | Drop elements from a list until a prefix is found.
dropUntil :: Eq a => [a] -> [a] -> [a]
dropUntil prefix = go where
  go [] = []
  go xs
    | prefix `isPrefixOf` xs = xs
    | otherwise = go (tail xs)

-- | Lowercase a string
lowerCase :: String -> String
lowerCase = map toLower
