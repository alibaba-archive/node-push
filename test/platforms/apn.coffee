assert = require('assert')
qs = require('querystring')
config = require('../private/config')
pusher = require('../../src/')

pusher.configure(config)

describe 'push#units/platforms/apn', ->
  params =
    deviceToken: 'bff70f75acb726ebf13d356ada5a655569c252841b3ac458ef8ebdb13b68ce7a'
    alert: 'hello world'
    category: 'hello world'
    badge: 1
    sound: 'ping.aiff'

  describe 'apn@push', ->
    it 'should get the correct without error', (done) ->
      pusher.apn.send params,
      setTimeout(done, 5000)

  describe 'apn@feedback', ->
    it 'should get the devices', (done) ->
      params =
        deviceToken: 'bff70f75acb726ebf13d356ada5a655569c252841b3ac458ef8ebdb13b68ce7a'
        alert: 'hello world'
        category: 'hello world'
        badge: 1
        sound: 'ping.aiff'
      pusher.apn.send params
      pusher.apn.getInvalidDevices (error, devices) ->
        return done(error) if error
        assert.strictEqual(devices instanceof Array, true)
        done()
