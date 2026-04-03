all: render serve
	
render:
	quarto render

serve:
	serve docs

deploy:
	quarto publish gh-pages