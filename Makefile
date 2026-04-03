all: render serve
	
render:
	quarto render

serve:
	serve public
	