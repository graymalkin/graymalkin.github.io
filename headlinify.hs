#!/usr/bin/env stack runghc --package pandoc-types
{-# LANGUAGE OverloadedStrings #-}

import Text.Pandoc.JSON
import Text.Pandoc.Generic
import qualified Data.Text as T
import Data.Map (mapWithKey, insert, findWithDefault)

headlineInline :: Inline -> Inline
headlineInline (Str x) = Span ("", ["headline-word"], []) [Str x]
headlineInline x = x

headlinifyBlock :: Block -> Block
headlinifyBlock (Header n id content) = Header n id (map headlineInline content)
headlinifyBlock x = x

headlinifyMetaInline :: MetaValue -> MetaValue
headlinifyMetaInline (MetaInlines inls) = MetaInlines (map headlineInline inls)
headlinifyMetaInline x = x

addDisplayMetaValue :: T.Text -> Meta -> Meta
addDisplayMetaValue field (Meta m) = 
    let headlinified = headlinifyMetaInline (findWithDefault (MetaInlines []) field m) in
    let newField = T.concat ["display", field] in
    Meta (insert newField headlinified m)

headlinify :: Pandoc -> Pandoc
headlinify = (bottomUp (addDisplayMetaValue "title")) . (bottomUp (addDisplayMetaValue "subtitle")) . (bottomUp headlinifyBlock)

main :: IO ()
main = toJSONFilter headlinify
