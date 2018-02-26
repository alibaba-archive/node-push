/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const assert = require('assert')
const config = require('../private/config')
const pusher = require('../../src/')

pusher.configure(config)

describe('push#units/platforms/apn', function () {
  let params = {
    deviceToken: 'c4131f53c920aad3447ce3b6021169ac37e41073278dd7a797ad1ffab04ad224',
    alert: 'hello world',
    category: 'hello world',
    badge: 1,
    sound: 'ping.aiff'
  }

  describe('apn@push', () =>
    it('should get the correct without error', done =>
      pusher.apn.send(params,
        setTimeout(done, 5000))
    )
  )

  return describe('apn@feedback', () =>
    it('should get the devices', function (done) {
      params = {
        deviceToken: 'bff70f75acb726ebf13d356ada5a655569c252841b3ac458ef8ebdb13b68ce7a',
        alert: 'hello world',
        category: 'hello world',
        badge: 1,
        sound: 'ping.aiff'
      }
      pusher.apn.send(params)
      pusher.apn.getInvalidDevices(function (error, devices) {
        if (error) { return done(error) }
        assert.strictEqual(devices instanceof Array, true)
        return done()
      })
    })
  )
})
