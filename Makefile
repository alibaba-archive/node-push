all:

test: test-apn test-xiaomi test-mailgun

test-apn:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/platforms/apn.coffee

test-mailgun:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/platforms/mailgun.coffee

test-xiaomi:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/platforms/xiaomi.coffee

.PHONY: all
