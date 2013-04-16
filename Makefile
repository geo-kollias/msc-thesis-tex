MAIN=thesis

#DEFAULT_LATEX=/cygdrive/c/opt/MiKTeX\ 2.5/miktex/bin/latex.exe
DEFAULT_LATEX=latex
#LATEX=/cygdrive/c/opt/MiKTeX\ 2.5/miktex/bin/latex.exe
LATEX=latex
PDFLATEX=pdflatex
BIBTEX=bibtex
#DVIPS=/cygdrive/c/opt/MiKTeX\ 2.5/miktex/bin/dvips.exe
DVIPS=dvips
#PS2PDF=/cygdrive/c/opt/MiKTeX\ 2.5/miktex/bin/ps2pdf.exe
PS2PDF=ps2pdf


# \nonstopmode force the compilation to the end
compile: 
	$(DEFAULT_LATEX) "\nonstopmode\input{$(MAIN).tex}"

i: interactive

interactive:
	$(DEFAULT_LATEX) "$(MAIN).tex"

final:
	$(DEFAULT_LATEX) "\nonstopmode\input{$(MAIN).tex}"
	$(BIBTEX) $(MAIN)
	$(DEFAULT_LATEX) "\nonstopmode\input{$(MAIN).tex}"
	$(DEFAULT_LATEX) "\nonstopmode\input{$(MAIN).tex}"
	$(DEFAULT_LATEX) "\nonstopmode\input{$(MAIN).tex}"
	$(DVIPS) -tletter -Ppdf -G0 $(MAIN)
	$(PS2PDF) $(MAIN).ps

bib: bibtex

bibtex:
	$(BIBTEX) $(MAIN)

#all: bibtex main main main ps
all: main bibtex main main main ps pdf

ps: $(MAIN).ps

pdf: $(MAIN).pdf

view: $(MAIN).dvi
	xdvi $(MAIN) &

edit:
	emacs $(MAIN).tex &

main: $(MAIN).dvi

lpr: print

print:	$(MAIN).ps
	lpr $(MAIN).ps

commit:
	cvs-commit -x $(MAIN).pdf,$(MAIN).ps

add:
	cvs -Q add $(wildcard *.tex) $(wildcard *.bib) $(wildcard *.sty) $(wildcard *.std) $(wildcard *.cls) $(wildcard *.nb) $(wildcard *.fig) $(wildcard *.pstex_t) $(wildcard *.pstex) $(wildcard *.eps_t) $(wildcard *.eps) $(wildcard *.jpg) $(wildcard *.png) $(filter-out $(MAIN).pdf,$(wildcard *.pdf))

update:
	cvs update

clean:
	rm -f *~ *.bak *.dvi $(MAIN).ps $(MAIN).pdf *.bbl *.blg *.aux *.log *.thm  *.snm *.toc *.out *.nav

tar:
	rm -f $(MAIN).tar.gz
	tar cvfz ../$(MAIN).tar.gz *.tex *.sty *.bib *.std *.fig *.eps *.pstex_t *.pstex *.jpg *.png *.nb

EPSFIGS=$(patsubst %.jpg,%.eps,$(wildcard *.jpg)) $(patsubst %.png,%.eps,$(wildcard *.png)) $(patsubst %.pdf,%.eps,$(filter-out $(MAIN).pdf,$(wildcard *.pdf)))
PDFFIGS=$(filter-out $(patsubst %.jpg,%.pdf,$(wildcard *.jpg)) $(patsubst %.png,%.pdf,$(wildcard *.png)),$(patsubst %.eps,%.pdf,$(wildcard *.eps)))
ALLFIGS=$(EPSFIGS) $(PDFFIGS)

figures: $(ALLFIGS)


$(MAIN).pdf: $(MAIN).ps
	$(PS2PDF) $(MAIN).ps

$(MAIN).dvi: $(wildcard *.tex) $(wildcard *.eps) $(wildcard *.pstex_t) 
	$(LATEX) "\nonstopmode\input{$(MAIN).tex}"

$(MAIN).ps: $(MAIN).dvi
	$(DVIPS) -tletter -Ppdf -G0 $(MAIN)

%.eps: %.png
	convert $< $@

%.eps: %.jpg
	convert $< $@

%.pdf: %.eps
	epstopdf $< 

