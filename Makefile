.ONESHELL:
SHELL := /bin/bash
SRC = $(wildcard ./*.ipynb)

all: pcitpy clean_nbs docs docs_serve

pcitpy: $(SRC)
	jupytext --to ipynb *.py
	nbdev_build_lib

sync:
	nbdev_update_lib

docs_serve: docs
	cd docs && bundle exec jekyll serve

docs: $(SRC)
	nbdev_build_docs

test:
	nbdev_test_nbs

release: pypi
	nbdev_conda_package
	nbdev_bump_version

pypi: dist
	twine upload --repository pypi dist/*

dist: clean
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist

clean_nbs: $(SRC)
	nbdev_clean_nbs