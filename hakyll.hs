{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (mplus)
import Data.Char (toLower)
import Data.Maybe (fromMaybe, isJust)
import Data.Monoid ((<>))
import Hakyll
import Hakyll.Contrib.Hyphenation (hyphenateHtml, english_GB)
import System.Process (readProcess)
import Text.Pandoc.Definition (Pandoc, Block(..), Format(..))
import Text.Pandoc.Options (WriterOptions(..))
import Text.Pandoc.Walk (walkM)

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

  -- Render index page
  create ["index.html"] $
    memoList False tags "Memos" "memos/*"

memoList :: Bool -> Tags -> String -> Pattern -> Rules ()
memoList ret tags title pat = do
  route idRoute
  compile $ do
    entries <- recentFirst =<< loadAll pat
    let ctx = constField "title" title <>
              listField "memos" (memoCtx tags) (return entries) <>
              defaultContext

    makeItem ""
      >>= hyphenateHtml english_GB
      >>= loadAndApplyTemplate "templates/memo-list.html" ctx
      >>= (if ret then loadAndApplyTemplate "templates/return.html" ctx else pure)
      >>= loadAndApplyTemplate "templates/wrapper.html"   ctx
      >>= relativizeUrls

memoCtx :: Tags -> Context String
memoCtx tags = mconcat
  [ dateField "isodate" "%Y-%m-%d"
  , dateField "ppdate"  "%B %e, %Y"
  , tagsField "tags"    tags
  , defaultContext
  ]

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

  -- Apply language-specific syntax highlighting. For some reason
  -- Haskell source in .lhs files is reported as "sourcecode". There
  -- may be other edge cases, but as I never want to highlight
  -- anything other than Haskell that is fine.
  withLanguage lang = let lang' = map toLower lang in if lang' == "sourcecode" then go "haskell" else go lang'
    where
      go highlightLang = readProcess "pygmentize" ["-l", highlightLang,  "-f", "html"]

-- | Build tags by merging the "tags" and "project" fields and adding
-- the "important" tag if that field is present.
buildTagsWithExtra :: MonadMetadata m => Pattern -> (String -> Identifier) -> m Tags
buildTagsWithExtra = buildTagsWith $ \identifier -> do
  metadata <- getMetadata identifier
  let fieldValue fld = fromMaybe [] $ lookupStringList fld metadata `mplus` (map trim . splitAll "," <$> lookupString fld metadata)
  let hasField   fld = isJust (lookupString fld metadata)
  pure $
    ["important"  | hasField "important"]  ++
    ["deprecated" | hasField "deprecated"] ++
    fieldValue "project" ++
    fieldValue "tags"

-- | Remove some portion of the route
dropPat :: String -> Routes
dropPat pat = gsubRoute pat (const "")
