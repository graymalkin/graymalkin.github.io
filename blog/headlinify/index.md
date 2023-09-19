---
title: Headlinify
subtitle: News style headlines without JavaScript
date: 19-09-2023
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

```hs
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
```