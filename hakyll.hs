{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Char (toLower)
import Data.Monoid ((<>))
import Hakyll
import System.Process (readProcess)
import Text.Pandoc.Definition (Pandoc, Block(..), Format(..))
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
  tags <- buildTags "memos/*" (fromCapture "tag/*.html")
  tagsRules tags $ \tag ->
    memoList True tags ("Tagged '" ++ tag ++ "'")

  -- Render memos
  match "memos/*" $ do
    route $
      setExtension ".html" `composeRoutes`
      dropPat      "memos/"
    compile $ pandocWithPygments
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
pandocWithPygments = pandocCompilerWithTransformM
                       defaultHakyllReaderOptions
                       defaultHakyllWriterOptions
                       pygmentize

-- | Apply pygments/pygmentize syntax highlighting to a Pandoc
-- document.
pygmentize :: Pandoc -> Compiler Pandoc
pygmentize = unsafeCompiler . walkM highlight where
  highlight (CodeBlock opts code) = RawBlock (Format "html") <$> case opts of
    (_, lang:_, _) -> withLanguage lang code
    _ -> pure $ "<div class =\"highlight\"><pre>" ++ escapeHtml code ++ "</pre></div>"
  highlight x = pure x

  -- Apply language-specific syntax highlighting
  withLanguage lang = readProcess "pygmentize" ["-l", map toLower lang,  "-f", "html"]

-- | Remove some portion of the route
dropPat :: String -> Routes
dropPat pat = gsubRoute pat (const "")
