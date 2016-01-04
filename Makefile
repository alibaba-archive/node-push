all: test

test:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/helper.coffee

.PHONY: all test
