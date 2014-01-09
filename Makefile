TESTS = $(shell find test -name "*.test.js")
MOCHA_OPTS= --check-leaks
REPORTER=spec
export NODE_ENV=test

test-integration:
	./node_modules/.bin/mocha --reporter ${REPORTER} $(MOCHA_OPTS) test/*.integration.test.js

test-unit:
	./node_modules/.bin/mocha --reporter $(REPORTER) $(MOCHA_OPTS) test/*.test.js

test: test-integration test-unit

lib-cov:
	@./node_modules/.bin/jscoverage lib lib-cov

html-cov: lib-cov
	@caminio_COV=1 ./node_modules/.bin/mocha --reporter html-cov > coverage.html

coverage:	html-cov

docs:
	yuidoc --config .yuidoc.json
	cp public/images/caminio-logo_200x35.png doc/logo-w-text.png
	cp public/images/favicon.png doc/logo.png


clean:
	rm -f coverage.html
	rm -rf lib-cov
	rm -rf doc

.PHONY: test clean
