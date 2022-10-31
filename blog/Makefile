TEMPLATE = ./blog-template.html

ARTICLES = church-js
OUTPUTS = $(patsubst %,%/index.html,$(ARTICLES)) index.html
INPTUS = $(patsubst %,%/index.md,$(ARTICLES))

.INTERMEDIATE: index.md

%.html: %.md $(TEMPLATE)
	pandoc -o $@ $< --highlight-style kate --template=$(TEMPLATE)

index.md: $(INPUTS)
	@echo "---" > index.md
	@echo "title: Blog" >> index.md
	@echo "---" >> index.md
	@for a in $(INPTUS); do \
		DATE=$$(grep -m 1 "date" $$a | sed -e 's/date: //g'); \
		TITLE=$$(grep -m 1 "title" $$a | sed -e 's/title: //g'); \
		echo " - <span style="color: \#666">($$DATE)</span> [$$TITLE](./$$(dirname $$a)/)" >> index.md; \
	done

all: $(OUTPUTS)

index.html : index.md
clean:
	rm -rf $(OUTPUTS)
	rm -f index.md
