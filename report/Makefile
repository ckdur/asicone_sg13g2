all: pdf md

pdf:
	latexmk -pdf -interaction=nonstopmode -outdir=build report.tex
	cp build/report.pdf report.pdf

# Markdown chapters for reading in the repository (needs the aux file of the PDF build)
md: pdf
	python3 make_md.py

clean:
	rm -rf build report.pdf

.PHONY: all pdf md clean
