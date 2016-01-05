urllib = require 'urllib'
qs = require 'qs'
httpsAgent = new (require('https').Agent)({keepAlive: true})
EventEmitter = require('events').EventEmitter

class XiaomiPlatform extends EventEmitter

  send_uri: 'https://api.xmpush.xiaomi.com/v2/message/regid'
  method: 'POST'

  constructor: ->
    @apiKey = ''
    @apiSecret = ''

  configure: (options = {}) ->
    for key, val of options
      @[key] = val
    return @

  send: (data = {}) ->
    extra = data.extra
    delete data.extra
    self = @

    uri = @send_uri + '?' + qs.stringify data
    urllib.request uri,
      method: @method
      contentType: 'json'
      data: extra
      httpsAgent: httpsAgent
      headers:
        Authorization: "key=#{@apiSecret}"
    , (err, body, res) ->
      try
        body = JSON.parse(body)
        err or= new Error(body.reason) if body?.result is 'error'
        self.emit 'error', err if err
      catch e
        err or= e
        self.emit 'error', err

module.exports = new XiaomiPlatform