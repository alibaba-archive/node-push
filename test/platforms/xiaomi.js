/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const assert = require('assert')
const qs = require('querystring')
const config = require('../private/config')
const pusher = require('../../src/')

pusher.configure(config)

describe('push#units/platforms/xiaomi', function () {
  const userId = 'd//igwEhgBGCI2TG6lWqlFIbnL5m7CRLMujCLirCvinYRpwCJnRqMTL0yfFeJhsXjmg9KEjl+1XxDieNFM7gpZtd+x8w8qGtZ0KMKuWZAn0='
  const params = {
    description: 'hello world',
    pass_through: 1,
    payload: qs.escape('hello world'),
    registration_id: userId,
    title: '',
    notify_type: 2
  }

  describe('xiaomi@push', () =>
    it('should be done without error', done =>
      pusher.xiaomi.send(params,
        setTimeout(done, 5000))
    )
  )

  return describe('xiaomi@get invalid devices', () =>
    it('return device list', done =>
      pusher.xiaomi.getInvalidDevices(function (error, devices) {
        if (error) { return done(error) }
        assert.strictEqual(devices instanceof Array, true)
        return done()
      })
    )
  )
})
