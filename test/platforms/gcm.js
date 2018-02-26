/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const assert = require('assert')
const nock = require('nock')
const config = require('../private/config')
const pusher = require('../../lib/')

pusher.configure(config)

describe('push#units/platforms/gcm', function () {
  describe('gcm@push', () => {
    it('should get the correct without error', function (done) {
      nock('https://gcm-http.googleapis.com')
        .post(/send/)
        .reply(200, {
          success: 1
        })
      const params = {
        to:
          'target device',
        data: {
          message: 'hello world'
        }
      }
      pusher.gcm.send(params, setTimeout(done, 500))
    })
  })

  describe('gcm push invalid device token', () =>
    it('should get the correct without error', function (done) {
      nock('https://gcm-http.googleapis.com')
        .post(/send/)
        .reply(200, {
          success: 0,
          results: [{
            error: 'InvalidRegistration'
          }]
        })

      const params = {
        to: 'abcdefg',
        data: {
          message: 'hello world'
        }
      }
      pusher.gcm.send(
        params,
        pusher.gcm.on('invalid device', function (device) {
          assert.equal(device, params.to)
          done()
        })
      )
    }))
})
