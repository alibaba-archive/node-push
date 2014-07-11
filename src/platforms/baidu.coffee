_ = require('underscore')
request = require('request')
crypto = require('crypto')

class BaiduPlatform

  host: 'http://channel.api.duapp.com'
  apiUri: '/rest/2.0/channel/channel'
  apiMethod: 'POST'

  constructor: ->
    @apiKey = ''
    @apiSecret = ''

  urlencode = (str) ->
    encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28')
    .replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+')

  ksort = (obj) ->
    keys = _.keys(obj)
    keys.sort (x, y) -> x > y
    _obj = {}
    _obj[k] = obj[k] for k in keys
    return _obj

  callback: (err, res) ->
    console.error("BAIDU-ERROR: ", err, res) if err?

  configure: (options = {}) ->
    for key, val of options
      @[key] = val

    return @

  sign: (params) ->
    url = @host + @apiUri
    params = ksort(params)
    paramsStr = ("#{k}=#{v}" for k, v of params).join('')
    rawStr = urlencode("#{@apiMethod}#{url}#{paramsStr}#{@apiSecret}")
    crypto.createHash('md5').update(rawStr).digest('hex')

  gMsgKeys: (bits = 64) ->
    rand = Math.floor(Math.random()*0x100000000)
    chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    ret = ''
    i = 26
    while bits > 0
      i -= 6
      bits -= 6
      ret += chars[0x3F & rand >>> i]
    return ret

  #  ref: http://developer.baidu.com/wiki/index.php?title=docs/cplat/push/api/list#push_msg
  #  method: push_msg
  #  apikey:
  #  user_id:
  #  push_type:
  #  channel_id: 1:user_id or channel_id 2:tag 3
  #  tag:
  #  device_type: 1:browser 2:pc 3:android 4:ios 5:wp
  #  message_type: 0: message 1: notice
  #  messages: string | object
  #  msg_keys: android | browser | pc
  #  message_expires: 86400
  #  deploy_status: 1: dev 2: pro
  #  timestamp:
  #  sign:
  #  expires: sign expires
  #  v:
  send: (data = {}, callback) ->

    # default
    data.apikey = @apiKey
    data.method or= 'push_msg'
    data.push_type or= 1
    data.timestamp = Math.round(Date.now() / 1000)
    data.msg_keys = 'teambition'
    unless data.message_type in [0,1]
      data.message_type = 0

    data.sign = @sign(data)

    callback or= @callback
    request
      uri: @host + @apiUri
      method: @apiMethod
      form: data
    , (err, res, body) ->
      try
        callback(err, JSON.parse(body))
      catch e
        callback(e, body)

baidu = new BaiduPlatform
baidu.BaiduPlatform = BaiduPlatform
module.exports = baidu
