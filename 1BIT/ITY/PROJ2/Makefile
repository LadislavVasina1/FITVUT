proj2.pdf: proj2.ps
	ps2pdf proj2.ps

proj2.ps: proj2.dvi
	dvips -sPAPERSIZE=a4 proj2.dvi

proj2.dvi: proj2.tex
	latex proj2.tex
	latex proj2.tex
