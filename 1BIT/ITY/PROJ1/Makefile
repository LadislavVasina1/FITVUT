proj1.pdf: proj1.ps
	ps2pdf proj1.ps

proj1.ps: proj1.dvi
	dvips -sPAPERSIZE=a4 proj1.dvi

proj1.dvi: proj1.tex
	latex proj1.tex
	latex proj1.tex
