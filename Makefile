show: clean solution.pdf 
	cp solution.pdf ~/public_html/bayesian-inference/solution-han.xiao-014343753.pdf
	chmod a+r ~/public_html/bayesian-inference/solution-han.xiao-014343753.pdf

solution.pdf: solution.tex
	pdflatex solution
	pdflatex solution

clean:
	rm -f *.aux *.log *~ *.pdf
