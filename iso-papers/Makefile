TEMPLATE = ./iso-papers-template.html
PANDOC_FLAGS = --standalone --citeproc --highlight-style kate --template=$(TEMPLATE) --mathjax --filter ../headlinify.hs

OUTPUTS = index.html

# Order is the index order. Maintain reverse chronological order.
# One .url file per paper, listing all revisions.
PAPERS = \
	p3881/p3881.url \
	p3692/p3692.url \
	p3111/p3111.url \
	p2850/p2850.url \
	p2426/p2426.url \
	p1780/p1780.url

CWG_ISSUES = \
	cwg/2923.url

.INTERMEDIATE: index.md

%.html: %.md $(TEMPLATE)
	pandoc $(PANDOC_FLAGS) -o $@ $<

index.md: $(PAPERS) $(CWG_ISSUES)
	@echo "---" > index.md
	@echo "title: ISO Papers" >> index.md
	@echo "---" >> index.md
	@echo "# Papers" >> index.md
	@for a in $(PAPERS); do \
		DATE=$$(grep -m 1 "^Date:" $$a | sed -e 's/^Date:[ ]*//'); \
		TITLE=$$(grep -m 1 "^Title:" $$a | sed -e 's/^Title:[ ]*//'); \
		SHORTNAME=$$(grep -m 1 "^Shortname:" $$a | sed -e 's/^Shortname:[ ]*//'); \
		DIR=$$(dirname $$a); \
		PARSED=$$(awk -v dir="$$DIR" ' \
			/^Revisions:[ \t]*$$/ {f=1; next} \
			f && /^[ \t]*-[ \t]/ { \
				sub(/^[ \t]*-[ \t]*/, ""); \
				n = index($$0, ":"); \
				tag = substr($$0, 1, n-1); \
				url = substr($$0, n+1); \
				sub(/^[ \t]+/, "", url); sub(/[ \t]+$$/, "", url); \
				if (url !~ /^https?:/ && url !~ /^\//) url = "./" dir "/" url; \
				if (revs != "") revs = revs ", "; \
				revs = revs "[" tag "](" url ")"; \
				latest = url; \
				next \
			} \
			f && !/^[ \t]*$$/ {f=0} \
			END { print revs "\t" latest } \
		' $$a); \
		REV_LINKS=$$(echo "$$PARSED" | cut -f1); \
		LATEST_URL=$$(echo "$$PARSED" | cut -f2); \
		echo " - <span style=\"color: #666\">($$DATE)</span> [$$SHORTNAME] [$$TITLE]($$LATEST_URL) <sup>[$$REV_LINKS]</sup>" >> index.md; \
	done
	@echo "" >> index.md
	@echo "# CWG Issues" >> index.md
	@for a in $(CWG_ISSUES); do \
		DATE=$$(grep -m 1 "^Date:" $$a | sed -e 's/^Date:[ ]*//'); \
		TITLE=$$(grep -m 1 "^Title:" $$a | sed -e 's/^Title:[ ]*//'); \
		SHORTNAME=$$(grep -m 1 "^Shortname:" $$a | sed -e 's/^Shortname:[ ]*//'); \
		HREF=$$(grep -m 1 "^URL:" $$a | sed -e 's/^URL:[ ]*//'); \
		echo " - <span style=\"color: #666\">($$DATE)</span> [$$SHORTNAME] [$$TITLE]($$HREF)" >> index.md; \
	done

all: $(OUTPUTS)

index.html : index.md
clean:
	rm -rf $(OUTPUTS)
	rm -f index.md
