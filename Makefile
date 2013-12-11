TESTS = $(shell find test -name "*.test.js")
export NODE_ENV=test

test:
	@./node_modules/.bin/mocha -u bdd $(TESTS)
.PHONY: test
