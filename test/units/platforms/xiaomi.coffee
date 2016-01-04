assert = require('assert')
qs = require('querystring')
_ = require('underscore')
config = require('../../private/config')
pusher = require('../../../src/')

pusher.configure(config)

describe 'push#units/platforms/xiaomi', ->
  user_id =  config.xiaomi.user_id
  params =
    description: 'hello world'
    pass_through: 1
    payload: qs.escape 'hello world'
    registration_id: user_id
    title: '',
    notify_type: 2,

  describe 'xiaomi@push', ->
    it 'should be done without error', (done) ->
      pusher.xiaomi.send params,
      setTimeout(done, 5000)
