include ../Makefile.mk
IMAGES_ORIGINAL = $(wildcard images/*-large.jpg)
IMAGES_RESIZED = $(patsubst %-large.jpg,%.jpg,$(IMAGES_ORIGINAL))

SUB_PAGES = \
	winter-24.md \
	spring-25.md

%/index.html : %.md
	mkdir -p $(basename $<)
	pandoc $(PANDOC_FLAGS) -o $@ $<

%.html : %.md
	pandoc $(PANDOC_FLAGS) -o $@ $<

images/%.jpg : images/%-large.jpg
	$(MAGICK) $< -resize ^1000x1000 $@

all: $(IMAGES_RESIZED) $(patsubst %.md,%/index.html,$(SUB_PAGES)) toc.md

clean:
	rm -rf $(IMAGES_RESIZED)
	rm -rf index.html toc.md
	rm -rf $(patsubst %.md,%,$(SUB_PAGES))
