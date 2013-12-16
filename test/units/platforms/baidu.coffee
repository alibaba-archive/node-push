should = require('should')
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
    # device_type: 3
    method: 'push_msg'
    timestamp: timestamp
    apikey: config.apikey
  {secret} = config

  describe 'baidu@sign', ->

    it 'should return correct sign string', ->

      sign = baidu.sign(method, url, params, secret)
      data = params
      data.sign = sign
      console.log data

