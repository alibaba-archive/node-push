urllib = require('urllib')
httpsAgent = new (require('https').Agent)({keepAlive: true})
EventEmitter = require('events').EventEmitter

class LuosimaoSMS extends EventEmitter

  sendURI = 'https://sms-api.luosimao.com/v1/send.json'
  statusURI = 'https://sms-api.luosimao.com/v1/status.json'

  constructor: ->
    @user = ''
    @apiKey = ''

  configure: (options = {}) ->
    for key, val of options
      @[key] = val
    return @

  send: (postData = {}) ->
    self = @
    if not postData.mobile?
      return @emit 'error', new Error('Mobile field is required')
    if not postData.message?
      return @emit 'error', new Error('Message field is required')
    if postData.message.length > 67
      return @emit 'error', new Error('The max length of message field is 67')
    urllib.request sendURI,
      method: 'POST'
      data: postData
      auth: "#{@user}:#{@apiKey}"
      agent: httpAgent
      httpsAgent: httpsAgent
    , (err, body, resp) ->
      try
        self.emit 'error', err, JSON.parse(body), postData if err
      catch e
        err or= e
        self.emit 'error', err, body, postData

  status: () ->
    self = @
    urllib.request statusURI,
      method: 'GET'
      auth: "#{@user}:#{@apiKey}"
      httpsAgent: httpsAgent
    , (err, body, resp) ->
      try
        self.emit 'error', err, JSON.parse(body), data if err
      catch e
        err or= e
        self.emit 'error', err, body, data

luosimao = new LuosimaoSMS
luosimao.LuosimaoSMS = LuosimaoSMS
exports = module.exports = luosimao