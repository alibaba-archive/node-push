all: test

test:
	@./node_modules/.bin/mocha -t 5000 --reporter spec --compilers coffee:coffee-script test/helper.coffee

.PHONY: all test
