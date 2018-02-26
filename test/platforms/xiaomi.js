/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const assert = require('assert')
const qs = require('querystring')
const nock = require('nock')
const config = require('../private/config')
const pusher = require('../../lib/')

pusher.configure(config)

describe('push#units/platforms/xiaomi', function () {
  const registrationId = 'any registration id'
  const params = {
    description: 'hello world',
    pass_through: 1,
    payload: qs.escape('hello world'),
    registration_id: registrationId,
    title: '',
    notify_type: 2
  }

  describe('xiaomi@push', () => {
    before(() => {
      nock('https://api.xmpush.xiaomi.com')
        .post(/regid/)
        .reply(200, {
          result: 'ok',
          description: '成功',
          data: { id: '1000999_1375164696370' },
          code: 0,
          info: 'Received push messages for 1 regid'
        })
    })

    it('should be done without error', done => {
      pusher.xiaomi.send(params, setTimeout(done, 2000))
    })
  })

  describe('xiaomi@get invalid devices', () => {
    before(() => {
      nock('https://feedback.xmpush.xiaomi.com')
        .get(/fetch_invalid_regids/)
        .reply(200, {
          result: 'ok',
          description: '成功',
          data: { list: ['regid1', 'regid2', 'regid3'] },
          code: 0
        })
    })

    it('return device list', done => {
      pusher.xiaomi.getInvalidDevices(function (error, devices) {
        if (error) {
          return done(error)
        }
        assert.strictEqual(devices instanceof Array, true)
        done()
      })
    })
  })
})
