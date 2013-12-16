_ = require('underscore')
request = require('request')
crypto = require('crypto')

class BaiduPlatform

  host: 'http://channel.api.duapp.com'
  apiUri: '/rest/2.0/channel/channel'
  apiMethod: 'POST'

  urlencode = (str) ->
    encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28')
    .replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+')

  ksort = (obj) ->
    keys = _.keys(obj)
    keys.sort (x, y) -> x > y
    _obj = {}
    _obj[k] = obj[k] for k in keys
    return _obj

  errorCallback: (err) ->
    console.error("BAIDU-ERROR: ", err)

  configure: (options = {}) ->
    for key, val of options
      @[key] = val

    return @

  sign: (params) ->

    url = @host + @apiUri

    params = ksort(params)
    paramsStr = ("#{k}=#{v}" for k, v of params).join('')
    rawStr = urlencode("#{@apiMethod}#{url}#{paramsStr}#{@secret}")
    crypto.createHash('md5').update(rawStr).digest('hex')

  send: (data, callback = ->) ->

    data.sign = @sign(data)

    request
      uri: @host + @apiUri
      method: @apiMethod
      form: data
    , (err, res, body) ->
      return callback(err, body)

baidu = new BaiduPlatform
baidu.BaiduPlatform = BaiduPlatform
module.exports = baidu
