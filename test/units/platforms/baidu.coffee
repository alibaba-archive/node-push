should = require('should')
_ = require('underscore')
config = require('../../private/config')
pusher = require('../../../lib')

pusher.configure(config)

describe 'push#units/platforms/baidu', ->

  timestamp = Math.round(Date.now() / 1000)
  params =
    push_type: 3
    messages: 'Hello World!'
    msg_keys: 'msg_key'
    method: 'push_msg'
    timestamp: timestamp
  {apiSecret} = config.baidu

  describe 'baidu@sign', ->

    it 'should return correct sign string', ->
      data = _.clone(params)
      data.apikey = config.baidu.apikey
      data.sign = pusher.baidu.sign(data)
      console.log data

  describe 'baidu@push', ->

    it 'should get the correct callback', (done) ->
      data = _.clone(params)
      pusher.baidu.send data, (err, result) ->
        result = JSON.parse(result)
        result.response_params.success_amount.should.be.eql(1)
        done()
