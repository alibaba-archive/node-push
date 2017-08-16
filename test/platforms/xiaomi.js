/* global describe, it */
const assert = require('assert')
const qs = require('querystring')
const config = require('../private/config')
const pusher = require('../../lib/')

pusher.configure(config)

describe('push#units/platforms/xiaomi', function () {
  let userId = 'd//igwEhgBGCI2TG6lWqlFIbnL5m7CRLMujCLirCvinYRpwCJnRqMTL0yfFeJhsXjmg9KEjl+1XxDieNFM7gpZtd+x8w8qGtZ0KMKuWZAn0='
  let params = {
    description: 'hello world',
    pass_through: 1,
    payload: qs.escape('hello world'),
    registration_id: userId,
    title: '',
    notify_type: 2
  }
  describe('xiaomi@push', function () {
    it('should be done without error', function (done) {
      pusher.xiaomi.send(params)
      setTimeout(done, 5000)
    })
  })

  describe('xiaomi@get invalid devices', function () {
    it('return device list', function (done) {
      pusher.xiaomi.getInvalidDevices(function (error, devices) {
        if (error) return done(error)
        assert.strictEqual(devices instanceof Array, true)
        done()
      })
    })
  })
})
