/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const assert = require('assert')
const config = require('../private/config')
const pusher = require('../../src/')

pusher.configure(config)

describe('push#units/platforms/gcm', function () {
  describe('gcm@push', () =>
    it('should get the correct without error', function (done) {
      const params = {
        to:
          'd5qC2izz3BQ:APA91bHdzZoXMGgOOx7vAAjavavS4jgA1RdlG6vfnjr5RArxj1GBLXaGpYo-I64yeNAMc3ADH-m9qghPkWS_9Ih5GVUG74YjKo9lpNVkygmNA_T8kZ5VZUF-RwBvnE7opr5ptO603DDV',
        data: {
          message: 'hello world'
        }
      }
      return pusher.gcm.send(params, setTimeout(done, 5000))
    }))

  return describe('gcm push invalid device token', () =>
    it('should get the correct without error', function (done) {
      const params = {
        to: 'abcdefg',
        data: {
          message: 'hello world'
        }
      }
      return pusher.gcm.send(
        params,
        pusher.gcm.on('invalid device', function (device) {
          assert.equal(device, params.to)
          return done()
        })
      )
    }))
})
