const assert = require('assert')
const { EventEmitter } = require('events')
const sinon = require('sinon')
const apn = require('apn')
const config = require('../private/config')
const pusher = require('../../lib/')

pusher.configure(config)

describe('push#units/platforms/apn', function () {
  let params = {
    deviceToken: 'abcdef',
    alert: 'hello world',
    category: 'hello world',
    badge: 1,
    sound: 'ping.aiff'
  }

  describe('apn@push', () =>
    it('should get the correct without error', () => {
      let spy = sinon.spy(pusher.apn.connection, 'pushNotification')

      pusher.apn.send(params)
      assert.strictEqual(spy.calledOnce, true)

      spy.restore()
    })
  )

  describe('apn@feedback', () =>
    it('should get the devices', function (done) {
      params = {
        deviceToken: 'abcdef',
        alert: 'hello world',
        category: 'hello world',
        badge: 1,
        sound: 'ping.aiff'
      }
      pusher.apn.send(params)

      class MockFeedback extends EventEmitter {
        constructor () {
          super()
          setTimeout(() => {
            this.emit('feedback', [])
          }, 0)
        }
      }

      let stub = apn.Feedback
      apn.Feedback = MockFeedback

      pusher.apn.getInvalidDevices(function (error, devices) {
        if (error) {
          return done(error)
        }
        assert.strictEqual(devices instanceof Array, true)
        apn.Feedback = stub

        done()
      })
    }))
})
