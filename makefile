.DEFAULT_GOAL := help

SHELL = bash -o pipefail

.PHONY: test
test:
	./bin/runtests | ./bin/colorizetap

.PHONY: pretty
pretty:
	fish_indent -w ./**/*.fish
	fish_indent -w ./bin/runtests

.PHONY: help
help:
	@echo "help    show this message"
	@echo "test    run tests"
	@echo "pretty  Run fish_indent against all fish files. "
