request = require 'request'
qs = require 'qs'

class XiaomiPlatform

  send_uri: 'https://api.xmpush.xiaomi.com/v2/message/regid'
  method: 'POST'

  constructor: ->
    @apiKey = ''
    @apiSecret = ''

  configure: (options={}) ->
    for key, val of options
      @[key] = val
    return @

  send: (data = {}, callback = ->)->
    self = @

    extra = data.extra
    delete data.extra

    uri = self.send_uri + '?' + qs.stringify data
    request
      uri: uri
      method: self.method
      json: true
      form: extra
      headers:
        Authorization: "key=#{self.apiSecret}"
    , (err, res, body) ->
      callback err, body

module.exports = new XiaomiPlatform