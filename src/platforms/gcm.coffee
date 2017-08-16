request = require('request')
Sock5Agent = require('socks5-https-client/lib/Agent')
EventEmitter = require('events').EventEmitter
Agent = require('https').Agent

gcmUrl = 'https://gcm-http.googleapis.com/gcm/send'
defaultOptions = {}

class GCM extends EventEmitter
  constructor: ->
    super
    @options = Object.create(defaultOptions)

  configure: (options = {}) ->
    for key, val of options
      @options[key] = val
    if @options.use_proxy
      @agent = new Sock5Agent
        socksHost: @options.ss_proxy_host or 'localhost'
        socksPort: @options.ss_proxy_port or 1080
    else
      @agent = new Agent
    return @

  send: (data = {}) ->
    self = @
    request
      url: gcmUrl
      httpsAgent: @agent
      method: 'POST'
      headers: Authorization: 'key=' + @options.apiKey
      dataType: 'json'
      contentType: 'json'
      data: data
    , (err, body, resp) ->
      return self.emit(err) if err
      return self.emit(new Error(body.error)) if body.error
      return self.emit(new Error(body)) if resp.status >= 300
      if body.results and Array.isArray(body.results)
        body.results.map (result, i) ->
          return unless data.to or data.registration_ids
          reg_id = data.to or data.registration_ids?[i]
          self.emit('invalid device', reg_id) if result.error

gcm = new GCM
gcm.GCM = GCM
exports = module.exports = gcm
