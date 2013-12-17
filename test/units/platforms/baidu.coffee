should = require('should')
_ = require('underscore')
config = require('../../private/config')
pusher = require('../../../lib')

pusher.configure(config)

describe 'push#units/platforms/baidu', ->

  timestamp = Math.round(Date.now() / 1000)
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

    it 'should get the correct callback', (done) ->
      pusher.baidu.send params, (err, result) ->
        console.log result
        result = JSON.parse(result)
        result.response_params.success_amount.should.be.eql(1)
        done()
