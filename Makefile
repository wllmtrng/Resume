SRC = $(wildcard *.md)

# PDFS=$(SRC:.md=.pdf)
# HTML=$(SRC:.md=.html)
PDFS=resume.pdf
HTML=resume.html
LATEX_TEMPLATE=./pandoc-templates/default.latex

all:    clean $(PDFS) $(HTML) README.md

pdf:   clean $(PDFS)
html:  clean $(HTML)

%.html: %.md
	python resume.py html $(GRAVATAR_OPTION) < $< | pandoc -t html -c resume.css -o $@

%.pdf:  %.md $(LATEX_TEMPLATE)
	python resume.py tex < $< | pandoc $(PANDOCARGS) --template=$(LATEX_TEMPLATE) -H header.tex -o $@

%.tex:  %.md $(LATEX_TEMPLATE)
	python resume.py tex < $< | pandoc $(PANDOCARGS) --template=$(LATEX_TEMPLATE) -H header.tex -o $@

README.md: resume.md
	cp $< $@
ifeq ($(OS),Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix
  RM = rm -f
endif

clean:
	$(RM) *.html *.pdf README.md

$(LATEX_TEMPLATE):
	git submodule update --init
