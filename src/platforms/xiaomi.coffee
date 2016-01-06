urllib = require('urllib')
qs = require('querystring')
EventEmitter = require('events').EventEmitter
httpsAgent = new (require('https').Agent)({keepAlive: true})

class XiaomiPlatform extends EventEmitter

  options:
    apiKey: ''
    apiSecret: ''
    send_uri: 'https://api.xmpush.xiaomi.com/v2/message/regid'
    invalid_regid_uri: 'https://feedback.xmpush.xiaomi.com/v1/feedback/fetch_invalid_regids'
    method: 'POST'

  getInvalidDevices: (callback) ->
    urllib.request @options.invalid_regid_uri,
      httpsAgent: httpsAgent
      headers:
        Authorization: "key=#{@options.apiSecret}"
    , (err, body, res) ->
      try
        list = []
        body = JSON.parse(body)
        err or= new Error(body.reason) if body?.result is 'error'
        list = body.data.list
        callback(err, list)
      catch e
        err or= e
        callback(err, body)

  configure: (options = {}) ->
    for key, val of options
      @options[key] = val
    return @

  send: (data = {}) ->
    extra = data.extra
    delete data.extra

    uri = @options.send_uri + '?' + qs.stringify(data)
    urllib.request uri,
      method: @options.method
      contentType: 'json'
      data: extra
      httpsAgent: httpsAgent
      headers:
        Authorization: "key=#{@options.apiSecret}"
    , (err, body, res) =>
      try
        body = JSON.parse(body)
        err or= new Error(body.reason) if body.result is 'error'
        @emit 'error', err if err
      catch e
        err or= e
        @emit 'error', err

module.exports = new XiaomiPlatform
