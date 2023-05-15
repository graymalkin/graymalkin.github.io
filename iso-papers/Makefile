TEMPLATE = ./iso-papers-template.html
PANDOC_FLAGS = --standalone --citeproc --highlight-style kate --template=$(TEMPLATE) --mathjax

OUTPUTS = index.html

# Order is the index order. Maintain reverse chronological order.
INPTUS = \
	p2850/p2850r0.bs \
	p1780/p1780r2.bs \
	p2426/p2426r0.bs \
	p1780/p1780r1.bs \
	p1780/p1780r0.bs

.INTERMEDIATE: index.md

%.html: %.md $(TEMPLATE)
	pandoc $(PANDOC_FLAGS) -o $@ $< 

index.md: $(INPUTS)
	@echo "---" > index.md
	@echo "title: ISO Papers" >> index.md
	@echo "---" >> index.md
	@for a in $(INPTUS); do \
		DATE=$$(grep -m 1 "Date" $$a | sed -e 's/Date: //g'); \
		TITLE=$$(grep -m 1 "Title" $$a | sed -e 's/Title: //g'); \
		SHORTNAME=$$(grep -m 1 "Shortname" $$a | sed -e 's/Shortname: //g'); \
		REVISION=$$(grep -m 1 "Revision" $$a | sed -e 's/Revision: //g'); \
		echo " - <span style=\"color: #666\">($$DATE)</span> [$$SHORTNAME r$$REVISION] [$$TITLE](./$$(echo $$a | sed -e 's/.bs/.html/g'))" >> index.md; \
	done

all: $(OUTPUTS)

index.html : index.md
clean:
	rm -rf $(OUTPUTS)
	rm -f index.md
