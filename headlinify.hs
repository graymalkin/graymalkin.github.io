#!/usr/bin/env -S stack runghc --package pandoc-types
{-# LANGUAGE OverloadedStrings #-}

import Text.Pandoc.JSON
import Text.Pandoc.Generic
import qualified Data.Text as T
import Data.Map (mapWithKey, insert, findWithDefault)

headlineInline :: Inline -> Inline
headlineInline (Str x) = Span ("", ["headline-word"], []) [Str x]
-- headlineInline (Str x) = RawInline (Format "html") ("<span class=\"headline-word\">" <> x <> "</span>")
headlineInline x = x

intersperse :: a -> [a] -> [a]
intersperse i (x:y:ys) = x:i:intersperse i (y:ys)
intersperse _ xs = xs


headlinifyBlock :: Block -> Block
headlinifyBlock (Header n id content) = Header n id (intersperse Space (map headlineInline content))
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
