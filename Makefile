all:

test: test-apn test-xiaomi test-mailgun test-gcm

test-apn:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/platforms/apn.coffee

test-xiaomi:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/platforms/xiaomi.coffee

test-gcm:
	mocha -t 8000 --reporter spec --compilers coffee:coffee-script/register test/platforms/gcm.coffee

.PHONY: all
