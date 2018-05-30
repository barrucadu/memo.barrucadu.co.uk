{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}

module Main where

import           Control.Monad              (mplus)
import           Data.Char                  (toLower)
import           Data.List                  (isPrefixOf, sortBy)
import           Data.Maybe                 (fromMaybe, isJust)
import           Data.Monoid                ((<>))
import           Data.Ord                   (Down(..), comparing)
import           Data.Time.Format           (defaultTimeLocale)
import           Hakyll
import           Hakyll.Contrib.Hyphenation (english_GB, hyphenateHtml)
import           System.IO                  (hClose, hPutStrLn)
import           System.IO.Temp             (withSystemTempFile)
import           System.Process             (readProcess)
import           Text.Pandoc.Definition     (Block(..), Format(..), Pandoc)
import           Text.Pandoc.Options        (WriterOptions(..))
import           Text.Pandoc.Walk           (walkM)

main :: IO ()
main = hakyllWith defaultConfiguration $ do
  -- Templates
  match "templates/*" $
    compile templateCompiler

  -- Copy static files
  match "static/**" $ do
    route $ dropPat "static/"
    compile copyFileCompiler

  -- Minify CSS
  match "style.css" $ do
    route idRoute
    compile compressCssCompiler

  -- Tags
  tags <- buildTagsWithExtra "memos/*" (fromCapture "tag/*.html")
  tagsRules tags $ \tag ->
    memoList True tags ("Tagged '" ++ tag ++ "'")

  -- Render memos
  match "memos/*" $ do
    route $
      setExtension ".html" `composeRoutes`
      dropPat      "memos/"
    compile $ pandocWithPygments
      >>= hyphenateHtml english_GB
      >>= saveSnapshot "content"
      >>= loadAndApplyTemplate "templates/memo.html"    (memoCtx tags)
      >>= loadAndApplyTemplate "templates/return.html"  defaultContext
      >>= loadAndApplyTemplate "templates/wrapper.html" defaultContext
      >>= relativizeUrls

  -- Create feed
  create ["atom.xml"] $ do
    route     idRoute
    compile $ loadAllSnapshots "memos/*" "content"
      >>= fmap (take 10) . recentFirst
      >>= renderAtom feedCfg feedCtx

  -- Render index page
  create ["index.html"] $
    memoList False tags "Memos" "memos/*"

memoList :: Bool -> Tags -> String -> Pattern -> Rules ()
memoList ret tags title pat = do
  route idRoute
  compile $ do
    entries <- sortMemos =<< loadAll pat
    let ctx = constField "title" title <>
              listField "memos" (memoCtx tags) (return entries) <>
              defaultContext

    makeItem ""
      >>= hyphenateHtml english_GB
      >>= loadAndApplyTemplate "templates/memo-list.html" ctx
      >>= (if ret then loadAndApplyTemplate "templates/return.html" ctx else pure)
      >>= loadAndApplyTemplate "templates/wrapper.html"   ctx
      >>= relativizeUrls

-------------------------------------------------------------------------------

memoCtx :: Tags -> Context String
memoCtx tags = mconcat
  [ dateField "isodate" "%Y-%m-%d"
  , dateField "ppdate"  "%B %e, %Y"
  , tagsField "tags"    tags
  , defaultContext
  ]

feedCfg :: FeedConfiguration
feedCfg = FeedConfiguration
  { feedTitle       = "barrucadu's memos"
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

-- | The Pandoc compiler, but using pygments/pygmentize for syntax
-- highlighting.
pandocWithPygments :: Compiler (Item String)
pandocWithPygments = pandocCompilerWithTransformM ropts wopts pygmentize where
  ropts = defaultHakyllReaderOptions
  wopts = defaultHakyllWriterOptions
    { writerTableOfContents = True
    , writerTOCDepth = 5
    , writerSectionDivs = True
    , writerTemplate = Just "$if(toc)$<div id=\"contents\">$toc$</div>$endif$$body$"
    }

-- | Apply pygments/pygmentize syntax highlighting to a Pandoc
-- document.
pygmentize :: Pandoc -> Compiler Pandoc
pygmentize = unsafeCompiler . walkM highlight where
  highlight (CodeBlock opts code) = RawBlock (Format "html") <$> case opts of
    (_, lang:_, _) -> withLanguage lang code
    _ -> pure $ "<div class =\"highlight\"><pre>" ++ escapeHtml code ++ "</pre></div>"
  highlight x = pure x

  withLanguage lang
      -- For some reason Haskell source in .lhs files is reported as
      -- "sourcecode". There may be other edge cases, but as I never
      -- want to highlight anything other than Haskell that is fine.
      | lang' == "sourcecode" = go "haskell"
      | otherwise = go lang'
    where
      lang' = map toLower lang

      go "graphviz" = graphvizToHtml
      go highlightLang = readProcess "pygmentize" ["-l", highlightLang,  "-f", "html"]

-- | Add "important" and "deprecated" tags if those fields are
-- present.
buildTagsWithExtra :: MonadMetadata m => Pattern -> (String -> Identifier) -> m Tags
buildTagsWithExtra = buildTagsWith $ \identifier -> do
  metadata <- getMetadata identifier
  let fieldValue fld = fromMaybe [] $ lookupStringList fld metadata `mplus` (map trim . splitAll "," <$> lookupString fld metadata)
  let hasField   fld = isJust (lookupString fld metadata)
  pure $
    ["important"  | hasField "important"] ++
    ["deprecated" | hasField "deprecated_by"] ++
    fieldValue "tags"

-- | Remove some portion of the route
dropPat :: String -> Routes
dropPat pat = gsubRoute pat (const "")

-- | Sort memos by date (descending), with deprecated memos at the
-- bottom and important memos at the top.  Deprecated important memos
-- also go to the bottom.
sortMemos :: MonadMetadata m => [Item a] -> m [Item a]
sortMemos = sortByA info where
  sortByA f xs =
    fmap (map fst . sortBy (comparing snd)) $
    traverse (\x -> (x,) <$> f x) xs

  info item = do
    let identifier = itemIdentifier item
    metadata <- getMetadata identifier
    let isDeprecated = isJust (lookupString "deprecated_by" metadata)
    let isImportant  = isJust (lookupString "important" metadata)
    date <- getItemUTC defaultTimeLocale identifier
    pure (isDeprecated, Down isImportant, Down date)

-- | Render graphviz code.
graphvizToHtml :: String -> IO String
graphvizToHtml src = withSystemTempFile "memo-graphviz-" $ \tmpFile hFile -> do
  hPutStrLn hFile src
  hClose hFile
  dropUntil "<svg" <$> readProcess "dot" ["-Tsvg", tmpFile] ""

-- | Drop elements from a list until a prefix is found.
dropUntil :: Eq a => [a] -> [a] -> [a]
dropUntil prefix = go where
  go [] = []
  go xs
    | prefix `isPrefixOf` xs = xs
    | otherwise = go (tail xs)
