# include ./Makefile.mk
TEMPLATE = ${CURDIR}/blog-template.html
FILTER := ${CURDIR}/../headlinify.hs
export PANDOC_FLAGS := --standalone --toc --citeproc --highlight-style kate --template=$(TEMPLATE) --mathml --filter $(FILTER)

# Order is the index order. Maintain reverse chronological order.
ARTICLES = \
	allotment \
	myford-ml4 \
	headlinify \
	leaving-kent \
	home-assistant-heating-controller \
	barcamp-2022 \
	make-a-static-site \
	church-js

.INTERMEDIATE: index.md

index.md:
	@echo "---" > index.md
	@echo "title: Simon Cooksey" >> index.md
	@echo "subtitle: Blog" >> index.md
	@echo "---" >> index.md
	@for a in $(ARTICLES); do \
		cat $$a/toc.md >> index.md; \
	done

.PHONY: $(ARTICLES) index.md

$(ARTICLES):
	ART_DIR=$@ make -C $@ all

index.html : index.md
	pandoc $(PANDOC_FLAGS) -o $@ $< 

all: $(ARTICLES) index.html

clean:
	rm -f index.md
	for dir in $(ARTICLES); do \
		make -C $$dir clean; \
	done

