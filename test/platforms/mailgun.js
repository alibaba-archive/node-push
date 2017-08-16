/* global describe, it */
const pusher = require('../../lib/')
const config = require('../private/config')

pusher.configure(config)

describe('push#units/platforms/mailgun', function () {
  it('should be done without error', function (done) {
    pusher.mailgun.addSubscribe('month@leeqiang.mailgun.org', {
      subscribed: true,
      address: 'bc@qq.com',
      name: 'b_qq',
      description: 'test'
    }, function (err, body) {
      if (err) return done(err)
      done()
    })
  })

  it('should be done without error', function (done) {
    pusher.mailgun.updateSubscribe('month@leeqiang.mailgun.org', {
      subscribed: 'True',
      address: 'bc@qq.com',
      name: 'b_qq',
      description: 'test'
    }, function (err, body) {
      if (err) return done(err)
      done()
    })
  })

  it('should be done without error', function (done) {
    pusher.mailgun.updateSubscribe('month@leeqiang.mailgun.org', {
      subscribed: false,
      address: 'bc@qq.com',
      name: 'b_qq',
      description: 'test'
    }, function (err, body) {
      if (err) return done(err)
      done()
    })
  })

  it('should be done without error', function (done) {
    pusher.mailgun.deleteSubscribe('month@leeqiang.mailgun.org', {
      subscribed: true,
      address: 'bc@qq.com',
      name: 'b_qq',
      description: 'test'
    }, function (err, body) {
      if (err) return done(err)
      done()
    })
  })
})
