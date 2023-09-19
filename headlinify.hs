#!/usr/bin/env stack runghc --package pandoc-types
{-# LANGUAGE OverloadedStrings #-}

import Text.Pandoc.JSON
import Text.Pandoc.Generic
import qualified Data.Text as T
import Data.Map (mapWithKey)

headlineInline :: Inline -> Inline
headlineInline (Str x) = Span ("", ["headline-word"], []) [Str x]
headlineInline x = x

headlinifyBlock :: Block -> Block
headlinifyBlock (Header n id content) =   (Header n id (map headlineInline content))
headlinifyBlock x = x

headlinifyMetaKV :: T.Text -> MetaValue -> MetaValue
headlinifyMetaKV "title" (MetaInlines content) = MetaInlines (map headlineInline content)
headlinifyMetaKV "subtitle" (MetaInlines content) = MetaInlines (map headlineInline content)
headlinifyMetaKV _ x = x

headlinifyMetaValue :: Meta -> Meta
headlinifyMetaValue (Meta m) = Meta (mapWithKey headlinifyMetaKV m)

headlinify :: Pandoc -> Pandoc
headlinify = (bottomUp headlinifyMetaValue) . (bottomUp headlinifyBlock)

main :: IO ()
main = toJSONFilter headlinify
