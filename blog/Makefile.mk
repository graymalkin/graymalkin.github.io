MAGICK = convert

toc.md: index.md $(SUB_PAGES)
	@rm -f toc.md
	@touch toc.md
	@if [ -f "index.md" ] ; then \
		DATE=$$(grep -m 1 "date" index.md | sed -e 's/date: //g'); \
		TITLE=$$(grep -m 1 "title" index.md | sed -e 's/title: //g'); \
		PUBLISHED=$$(grep -m 1 "published" index.md | sed -e 's/published: //g'); \
		if [ $$PUBLISHED = true ]; then \
			echo " - <span style=\"color: #666\">($$DATE)</span> [$$TITLE](./$$ART_DIR/)" >> toc.md; \
		fi; \
	fi
	@for a in $(SUB_PAGES); do \
		DATE=$$(grep -m 1 "date" $$a | sed -e 's/date: //g'); \
		TITLE=$$(grep -m 1 "title" $$a | sed -e 's/title: //g'); \
		PUBLISHED=$$(grep -m 1 "published" $$a | sed -e 's/published: //g'); \
		if [ $$PUBLISHED = true ]; then \
			echo "     - <span style=\"color: #666\">($$DATE)</span> [$$TITLE](./$$ART_DIR/$$(basename $$a .md)/)" >> toc.md; \
		fi \
	done

%.html : %.md
	pandoc $(PANDOC_FLAGS) -o $@ $<

all: index.html toc.md
clean:
	rm -rf index.html
	rm -rf toc.md
	rm -rf $(IMAGES_RESIZED)

