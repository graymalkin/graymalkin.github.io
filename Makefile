TEMPLATE = ./template.html
FILTER = ./headlinify.hs
PANDOC_FLAGS = --standalone --toc --citeproc --highlight-style kate --template=$(TEMPLATE) --mathml --filter $(FILTER) --wrap=preserve

%.html: %.md $(TEMPLATE) $(FILTER)
	pandoc $(PANDOC_FLAGS) -o $@ $< 

all: index.html 404.html
	make -C blog/ all
	make -C iso-papers/ all

clean:
	rm -f index.html
	make -C blog/ clean
	make -C iso-papers/ clean
