should = require('should')
BaiduPlatform = require('../../../lib/platforms/baidu')
config = require('../../private/config')

baidu = new BaiduPlatform

describe 'push#units/platforms/baidu', ->

  method = 'POST'
  url = 'http://channel.api.duapp.com/rest/2.0/channel/channel'
  params =
    push_type: 3
    messages: 'Hello World!'
    msg_keys: 'msg_key'
    # device_type: 3
    method: 'push_msg'
    timestamp: 1386842571
    apikey: config.apikey
  {secret} = config

  describe 'baidu@sign', ->

    it 'should return correct sign string', ->

      console.log baidu.sign(method, url, params, secret)

