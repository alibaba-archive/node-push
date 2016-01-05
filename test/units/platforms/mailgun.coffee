pusher = require('../../../src/')
config = require('../../private/config')

pusher.configure(config)

describe 'push#units/platforms/mailgun', ->
  it 'should be done without error', (done) ->
    pusher.mailgun.addSubscribe 'month@leeqiang.mailgun.org',
      subscribed: true
      address: 'bc@qq.com'
      name: 'b_qq'
      description: 'test'
    , (err, body) ->
      return done(err) if err
      done()

  it 'should be done without error', (done) ->
    pusher.mailgun.updateSubscribe 'month@leeqiang.mailgun.org',
      subscribed: true
      address: 'bc@qq.com'
      name: 'b_qq'
      description: 'test'
    , (err, body) ->
      return done(err) if err
      done()

  it 'should be done without error', (done) ->
    pusher.mailgun.updateSubscribe 'month@leeqiang.mailgun.org',
      subscribed: false
      address: 'bc@qq.com'
      name: 'b_qq'
      description: 'test'
    , (err, body) ->
      return done(err) if err
      done()

  it 'should be done without error', (done) ->
    pusher.mailgun.deleteSubscribe 'month@leeqiang.mailgun.org',
      subscribed: true
      address: 'bc@qq.com'
      name: 'b_qq'
      description: 'test'
    , (err, body) ->
      return done(err) if err
      done()
