---
title: Headlinify
subtitle: News style headlines without JavaScript
date: 2023-09-20
published: true
toc: false
---

While re-designing this site, I wanted to use the newsprint style headlines for my headings.
To my dissatisfaction, it is very hard to style header (`<h1>`) elements using just CSS to produce this effect.
I had a look online, and a [stack overflow][stack-overflow-headline] post gave me a solution using JavaScript:

```js
<script>
let newHeadlineMarkup = "";
document.querySelectorAll("h1, h2, h3, h4, .byline")
    .forEach((headline, _) => {
    var newHeadingMarkup = "";
    headline.innerHTML
        .split(" ")
        .forEach((word, _) => {
        newHeadingMarkup += `<span class="headline-word">$${word}</span>`;
        }
    );
    headline.innerHTML = newHeadingMarkup;
    }
);
</script>
```

... and the corresponding css...

```css
.headline-word {
    display: inline;
    color: white;
    background: black;
    padding: 0.25em 0.25em 0.1em 0.25em;
    margin-bottom: 0.1em;
    border: solid 1px black;
}
```

This is in itself a bit annoying though!
The webpage subtly changes layout just after loading, causing an ugly flash, and this doesn't work at all for people who do not use javascript.

## Pandoc to the rescue

I could manually transform a heading element into `<h1><span class="headline-word">My</span> <span class="headline-word">Heading</span></h1>`, but that is quite tedious!
I still use Make and Pandoc to build this site, as described in [this post](/blog/make-a-static-site/), so I figured I could whip up a quick Pandoc filter which achieves the same aim as the JavaScript above instead.

There's two parts to the filter, one which makes modifies normal `# Headings`, through the `headlinifyBlock` function.

```hs
headlineInline :: Inline -> Inline
headlineInline (Str x) = Span ("", ["headline-word"], []) [Str x]
headlineInline x = x

headlinifyBlock :: Block -> Block
headlinifyBlock (Header n id content) = Header n id (map headlineInline content)
headlinifyBlock x = x
```

And a second part which copies the page title and subtitle metadata fields and makes new `display`-versions for use in the template.
This is necessary because modifying `$title$` directly yields page titles which contain raw HTML which displays in the browser tab title.

```hs
headlinifyMetaInline :: MetaValue -> MetaValue
headlinifyMetaInline (MetaInlines inls) = MetaInlines (map headlineInline inls)
headlinifyMetaInline x = x

addDisplayMetaValue :: T.Text -> Meta -> Meta
addDisplayMetaValue field (Meta m) = 
    let headlinified = headlinifyMetaInline (findWithDefault (MetaInlines []) field m) in
    let newField = T.concat ["display", field] in
    Meta (insert newField headlinified m)
```

Putting it all together, and adding a `#!` recipe so it can be run as a script rather than compiled, and we get this:

```hs
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
headlinify = 
    (bottomUp (addDisplayMetaValue "title")) . 
    (bottomUp (addDisplayMetaValue "subtitle")) . 
    (bottomUp headlinifyBlock)

main :: IO ()
main = toJSONFilter headlinify
```