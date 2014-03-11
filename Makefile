show: solution.pdf
	cp solution.pdf ~/public_html/bayesian-inference/solution-han.xiao-014343753.pdf
	chmod a+r ~/public_html/bayesian-inference/solution-han.xiao-014343753.pdf

solution.pdf: solution.tex
	cp MLE_and_BE/result.png imgs/mle-be-estimation.png
	pdflatex solution

clean:
	rm -f *.aux *.log *~ *.pdf
