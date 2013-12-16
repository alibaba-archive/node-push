should = require('should')
_ = require('underscore')
baidu = require('../../../lib/platforms/baidu')
config = require('../../private/config')

baidu = new baidu.BaiduPlatform

describe 'push#units/platforms/baidu', ->

  method = 'POST'
  url = 'http://channel.api.duapp.com/rest/2.0/channel/channel'
  timestamp = Math.round(Date.now() / 1000)
  params =
    push_type: 3
    messages: 'Hello World!'
    msg_keys: 'msg_key'
    method: 'push_msg'
    timestamp: timestamp
    apikey: config.apikey
  {secret} = config

  describe 'baidu@sign', ->

    it 'should return correct sign string', ->

      sign = baidu.sign(method, url, params, secret)
      data = _.clone(params)
      data.sign = sign
      console.log data

  describe 'baidu@push', ->

    it 'should get the correct callback', (done) ->

      data = _.clone(params)
      baidu.secret = config.secret
      baidu.send data, (err, result) ->
        result = JSON.parse(result)
        result.response_params.success_amount.should.be.eql(1)
        done()
