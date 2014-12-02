request = require 'request'

class LuosimaoSMS

  sendURI = 'https://sms-api.luosimao.com/v1/send.json'
  statusURI = 'https://sms-api.luosimao.com/v1/status.json' 

  constructor: ->
    @user = ''
    @apiKey = ''

  configure: (options = {}) ->
    for key, val of options
      @[key] = val
    return @

  send: (postData, callback) ->
    if not postData.mobile?
      return callback Error('Mobile field is required')
    if not postData.message?
      return callback Error('Message field is required')
    if postData.message.length > 67
      return callback Error('The max length of message field is 67')
    options = 
      uri: sendURI
      useQueryString: true
      method: 'POST'
      encoding: 'utf8'
      timeout: 5000
      form: postData
      auth:
        user: @user
        pass: @apiKey
    request options, (error, response, body) ->
      body = JSON.parse(body)
      callback(error, body)

  status: (callback) ->
    options =
      uri: statusURI
      method: 'GET'
      timeout: 5000
      auth:
        user: @user
        pass: @apiKey
      encoding: 'utf8'
    request options, (error, response, body) ->
      body = JSON.parse(body)
      callback(error, body)

luosimao = new LuosimaoSMS
luosimao.LuosimaoSMS = LuosimaoSMS
exports = module.exports = luosimao