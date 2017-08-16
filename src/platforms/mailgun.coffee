EventEmitter = require('events').EventEmitter
request = require('request')
httpsAgent = new (require('https').Agent)({keepAlive: true})

defaultOptions =
  apiUrl: 'api.mailgun.net'
  apiKey: ''
  domain: ''
# _ Example _
#  mailgun.send({
#    from: 'SKY <sky@leeqiang.mailgun.org>'
#    to: 'qiang@teambition.com'
#    subject: 'Hello, qiang'
#    html: '<h1>Qiang, 您好</h1>'
#    text: 'Qiang, 您好'
#  })
class Mailgun extends EventEmitter

  constructor: ->
    super
    @options = Object.create(defaultOptions)

  configure: (options = {}) ->
    for key, val of options
      @options[key] = val
    return @

  #  - data
  #    from:
  #    to:
  #    subject:
  #    html:
  #    text:
  #  - callback: (err, ret) ->
  send: (data, callback) ->
    return @emit 'error', new Error("domain is required") unless @options.domain
    api = "https://#{@options.apiUrl}/v2/#{@options.domain}/messages"
    @request(api, data, callback)

  callback: (err) ->
    @emit 'error', err if err

  addSubscribe: (listAddress, data = {}, callback) ->
    api = "https://#{@options.apiUrl}/v2/lists/#{listAddress}/members"
    data.method = 'POST'
    @request(api, data, callback)

  #Deprecated
  updateSubscribe: (listAddress, data = {}, callback) ->
    api = "https://#{@options.apiUrl}/v2/lists/#{listAddress}/members/#{data.address}"
    data.method = 'PUT'
    @request(api, data, callback)

  deleteSubscribe: (listAddress, data = {}, callback) ->
    api = "https://#{@options.apiUrl}/v2/lists/#{listAddress}/members/#{data.address}"
    data.method = 'DELETE'
    @request(api, data, callback)

  request: (api, data, callback) ->
    callback = @callback.bind(@) if typeof callback isnt 'function'
    return callback(new Error("apiKey is required")) unless @options.apiKey
    self = @
    request
      url: api
      method: data.method or 'POST'
      auth: "api:#{@options.apiKey}"
      data: data
      httpsAgent: httpsAgent
    , (err, body, resp) ->
      try
        body = JSON.parse(body)
        if resp.statusCode isnt 200
          err or= new Error(body.error or body.message or body)
      catch e
        err or= e
      callback err, body

mailgun = new Mailgun
mailgun.Mailgun = Mailgun
exports = module.exports = mailgun
