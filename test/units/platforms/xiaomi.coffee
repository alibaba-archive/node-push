assert = require('assert')
qs = require('querystring')
config = require('../../private/config')
pusher = require('../../../src/')

pusher.configure(config)

describe 'push#units/platforms/xiaomi', ->
  user_id = 'd//igwEhgBGCI2TG6lWqlFIbnL5m7CRLMujCLirCvinYRpwCJnRqMTL0yfFeJhsXjmg9KEjl+1XxDieNFM7gpZtd+x8w8qGtZ0KMKuWZAn0='
  params =
    description: 'hello world'
    pass_through: 1
    payload: qs.escape 'hello world'
    registration_id: user_id
    title: ''
    notify_type: 2

  describe 'xiaomi@push', ->
    it 'should be done without error', (done) ->
      pusher.xiaomi.send params,
      setTimeout(done, 5000)

  describe 'xiaomi@get invalid devices', ->
    it 'return device list', (done) ->
      pusher.xiaomi.getInvalidDevices (error, devices) ->
        return done(error) if error
        assert.strictEqual(devices instanceof Array, true)
        done()
