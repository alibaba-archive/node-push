should = require('should')
config = require('../../private/config')
pusher = require('../../../src/')

pusher.configure(config)

describe 'push#units/platforms/baidu', ->
  params =
    messages: JSON.stringify
      title: 'hello'
      description: "hello world again"
    user_id: config.baidu.user_id

  describe 'baidu@sign', ->
    it 'should return correct sign string', ->
      sign = pusher.baidu.sign(params)
      console.log sign

  describe 'baidu@push', ->
    it 'should get the correct without error', (done) ->
      pusher.baidu.send params
      setTimeout(done, 5000)
