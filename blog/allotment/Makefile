include ../Makefile.mk
IMAGES_ORIGINAL = $(wildcard images/*-large.jpg) $(wildcard images/summer-25/*-large.jpg)
IMAGES_RESIZED = $(patsubst %-large.jpg,%.jpg,$(IMAGES_ORIGINAL)) 

SUB_PAGES = \
	autumn-25.md \
	summer-25.md \
	spring-25.md \
	wildlife-25.md \
	winter-24.md

index.md: index-template.md
	cat index-template.md > index.md

toc.md : index.md

index.html : index.md toc.md
	cat toc.md >> index.md
	pandoc $(PANDOC_FLAGS) -o $@ index.md

%/index.html : %.md
	mkdir -p $(basename $<)
	pandoc $(PANDOC_FLAGS) --toc -o $@ $<

%.html : %.md
	pandoc $(PANDOC_FLAGS) -o $@ $<

images/%.jpg : images/%-large.jpg
	$(MAGICK) $< -resize ^1000x1000 $@

images: $(IMAGES_RESIZED)

all: images $(patsubst %.md,%/index.html,$(SUB_PAGES)) toc.md

clean:
	rm -rf $(IMAGES_RESIZED)
	rm -rf index.html index.md toc.md
	rm -rf $(patsubst %.md,%,$(SUB_PAGES))
