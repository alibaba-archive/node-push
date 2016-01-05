all:

test: test-apn test-xiaomi test-mailgun

test-apn:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/units/platforms/apn.coffee

test-mailgun:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/units/platforms/mailgun.coffee

test-xiaomi:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/units/platforms/xiaomi.coffee

.PHONY: all
