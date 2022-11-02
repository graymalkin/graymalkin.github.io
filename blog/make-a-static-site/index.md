---
title: Make a static website
subtitle: Building a static website with pandoc and Make
date: 2022-11-01
published: true
---

I'm a believer in simple static html based websites, but I'm not quite so dyed-in-the-wool that I want to write html by hand.
That being said, my homepage is built by hand in raw html, and edits I do are directly on the html.

That isn't very scalable, and I've recently started this blog.
In other projects, especially for the [TinkerSoc](https://tinkersoc.org) website, I've used static website generator tools.
First, we used [Jekyll](https://jekyllrb.com), a Ruby tool for turning markup into a whole website.
It's scriptable, extensible, generally quite good. It's even supported by github pages!
You can add a repo containing a jekyll website, and prod GitHub in the right way and they'll build it for you and host it at `https://username.github.io`.
Unfortunately, if you use GitHub's build, you can do quite a lot less with Ruby to extend it.

With poor performance, and weak github integration we eventually rebuilt the website using [Hugo](https://gohugo.com), a Go based static website generator built with the same aims - but it's _really_ fast.

All of these tools are pretty heavyweight though, and have significant learning curves.
I've done the hard work, I could use them for my website, but that would be procrastinating a little too much. So what am I doing instead? Well, just Pandoc and Makefiles.


# Building articles
First up: how do I build an individual post?
Well, that's easy, I can call pandoc on a `.md` file and fill in a template.

```makefile
TEMPLATE = ./blog-template.html
PANDOC_FLAGS = --standalone --highlight-style kate --template=$(TEMPLATE) --mathjax


%.html: %.md $(TEMPLATE)
	pandoc $(PANDOC_FLAGS) -o $@ $< 
```

Each article needs a front-matter block with the date, title, subtitle, and a published state:

```md
---
title: Make a static website
subtitle: Building a static website with pandoc and Make
date: 2022-11-01
published: true
---

I'm a believer in simple static html based websites, but I'm not quite so dyed-in-the-wool that I want to write html by hand.
...
```

# Template

Okay, the template.
Most of this is boilerplate that I've pulled from my home page. There are a few `$macro$`s which pandoc expands:

 - `$header-includes$` This allows me to specify extra `<head>` items for the html.
 - `$math$` pulls in MathJax so I can use $\LaTeX$ math expressions.
 - `$title$`, `$subtitle$`, `$date$` all expand to the obvious parts of the article that pandoc is typesetting.
 - `<style>$highlighting-css$</style>` includes some CSS to syntax highlight any source code.

```html
<!DOCTYPE html>
<html lang="en">
  <title>$title$ &mdash; Simon Cooksey Blog</title>
  <meta name="viewport" content="width=device-width, user-scalable=yes">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/firacode@6.2.0/distr/fira_code.css">
  <link rel="stylesheet" type="text/css" href="https://graymalk.in/style.css"/>
  <meta name="description" content="Personal webpage of Simon Cooksey, summarising academic research projects and funding.">
  <meta charset="utf-8">
$for(header-includes)$
  $header-includes$
$endfor$
$if(math)$
  $math$
$endif$
</head>
<body>
  <main>
    <h1 class="title">$title$</h1>
    <div class="byline">$subtitle$</div>
    <div class="date">$date$</div>
    <nav>
        <ul>
            <li><a href="/">Home</a></li>
            <li><a href="/blog/">Blog</a></li>
            <li><a href="/photography/">Photography</a></li>
        </ul>
    </nav>
    $body$
  </main>
  <style>$highlighting-css$</style>
</body>
</html>
```

# Building an index page

This is where Hugo and Jekyll excel, and pandoc is less useful.
Thankfully, I want a very simple index page, so a little bit of bash hacking to read the meta-data from the yaml block at the top of each article does the trick.
I build a custom `index.md` which will just turn into the bullet list I want after it runs through Pandoc.
Makefile as a metaprogramming language 😜.

I also have a flag which allows me to hid WIP articles from the index, but let me continue commiting the html.

```makefile
# Order is the index order. Maintain reverse chronological order.
ARTICLES = \
	barcamp-2022 \
    make-a-static-site \
	church-js

INPTUS = $(patsubst %,%/index.md,$(ARTICLES))


index.md: $(INPUTS)
	@echo "---" > index.md
	@echo "title: Blog" >> index.md
	@echo "---" >> index.md
	@for a in $(INPTUS); do \
		DATE=$$(grep -m 1 "date" $$a | sed -e 's/date: //g'); \
		TITLE=$$(grep -m 1 "title" $$a | sed -e 's/title: //g'); \
		PUBLISHED=$$(grep -m 1 "published" $$a | sed -e 's/published: //g'); \
		if [ $$PUBLISHED = true ]; then \
			echo " - <span style=\"color: #666\">($$DATE)</span> [$$TITLE](./$$(dirname $$a)/)" >> index.md; \
		fi \
	done
```

And there we have it!
A flexible static website, with markdown for writing articles, but a light-weight set of tools to build the index and each page.
