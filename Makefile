build:
	docker build -t melopt/mkdocs .

push: build
	docker push melopt/mkdocs
