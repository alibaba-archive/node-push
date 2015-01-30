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

  send: (data = {}, callback)->
    self = @

    uri = self.send_uri + '?' + qs.stringify data
    request
      uri: self.send_uri
      method: self.method
      json: true
      headers:
        Authorization: "key=#{self.apiSecret}"
    , (err, res, body) ->
      callback err, body

module.exports = new XiaomiPlatform