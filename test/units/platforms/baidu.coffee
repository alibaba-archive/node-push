should = require('should')
BaiduPlatform = require('../../../lib/platforms/baidu')
config = require('../../private/config')

baidu = new BaiduPlatform

describe 'push#units/platforms/baidu', ->

  method = 'GET'
  url = 'http://channel.api.duapp.com/rest/2.0/channel/channel'
  params =
    method: 'push_msg'
    apikey: config.apikey
    push_type: 3
    messages: 'Hello World!'
    msg_keys: '50c32ab5e8cf1439d35a82fb'
    timestamp: 1386838295
  {secret} = config

  describe 'baidu@sign', ->

    it 'should return correct sign string', ->

      console.log baidu.sign(method, url, params, secret)

