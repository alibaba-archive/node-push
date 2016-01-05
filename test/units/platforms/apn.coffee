assert = require('assert')
qs = require('querystring')
_ = require('underscore')
config = require('../../private/config')
pusher = require('../../../src/')

pusher.configure(config)

describe 'push#units/platforms/apn', ->
  user_id =  config.apn.user_id
  params =
    deviceToken: user_id
    alert: 'hello world'
    category: 'hello world'
    badge: 1
    sound: 'ping.aiff'

  describe 'apn@push', ->
    it 'should get the correct without error', (done) ->
      pusher.apn.send params,
      setTimeout(done, 5000)
