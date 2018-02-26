/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const pusher = require('../../src/')
const config = require('../private/config')

pusher.configure(config)

describe('push#units/platforms/mailgun', function () {
  it('should be done without error', done =>
    pusher.mailgun.addSubscribe('month@leeqiang.mailgun.org', {
      subscribed: true,
      address: 'bc@qq.com',
      name: 'b_qq',
      description: 'test'
    }
      , function (err, body) {
      if (err) { return done(err) }
      return done()
    })
  )

  it('should be done without error', done =>
    pusher.mailgun.updateSubscribe('month@leeqiang.mailgun.org', {
      subscribed: true,
      address: 'bc@qq.com',
      name: 'b_qq',
      description: 'test'
    }
      , function (err, body) {
      if (err) { return done(err) }
      return done()
    })
  )

  it('should be done without error', done =>
    pusher.mailgun.updateSubscribe('month@leeqiang.mailgun.org', {
      subscribed: false,
      address: 'bc@qq.com',
      name: 'b_qq',
      description: 'test'
    }
      , function (err, body) {
      if (err) { return done(err) }
      return done()
    })
  )

  return it('should be done without error', done =>
    pusher.mailgun.deleteSubscribe('month@leeqiang.mailgun.org', {
      subscribed: true,
      address: 'bc@qq.com',
      name: 'b_qq',
      description: 'test'
    }
      , function (err, body) {
      if (err) { return done(err) }
      return done()
    })
  )
})
