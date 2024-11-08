TEMPLATE = ./blog-template.html
PANDOC_FLAGS = --standalone --toc --citeproc --from markdown+grid_tables --highlight-style kate --template=$(TEMPLATE) --mathml --filter ../headlinify.hs

# Order is the index order. Maintain reverse chronological order.
ARTICLES = \
	myford-ml4 \
	headlinify \
	leaving-kent \
	home-assistant-heating-controller \
	barcamp-2022 \
	make-a-static-site \
	church-js

OUTPUTS = $(patsubst %,%/index.html,$(ARTICLES)) index.html
INPTUS = $(patsubst %,%/index.md,$(ARTICLES))

.INTERMEDIATE: index.md

%.html: %.md $(TEMPLATE)
	pandoc $(PANDOC_FLAGS) -o $@ $< 

index.md: $(INPUTS)
	@echo "---" > index.md
	@echo "title: Simon Cooksey" >> index.md
	@echo "subtitle: Blog" >> index.md
	@echo "---" >> index.md
	@for a in $(INPTUS); do \
		DATE=$$(grep -m 1 "date" $$a | sed -e 's/date: //g'); \
		TITLE=$$(grep -m 1 "title" $$a | sed -e 's/title: //g'); \
		PUBLISHED=$$(grep -m 1 "published" $$a | sed -e 's/published: //g'); \
		if [ $$PUBLISHED = true ]; then \
			echo " - <span style=\"color: #666\">($$DATE)</span> [$$TITLE](./$$(dirname $$a)/)" >> index.md; \
		fi \
	done

all: $(OUTPUTS)

index.html : index.md
clean:
	rm -rf $(OUTPUTS)
	rm -f index.md
