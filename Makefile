all:

test: test-apn test-xiaomi test-mailgun test-gcm

test-apn:
	mocha -t 8000 --reporter spec test/platforms/apn.js

test-mailgun:
	mocha -t 8000 --reporter spec test/platforms/mailgun.js

test-xiaomi:
	mocha -t 8000 --reporter spec test/platforms/xiaomi.js

test-gcm:
	mocha -t 8000 --reporter spec test/platforms/gcm.js

.PHONY: all
