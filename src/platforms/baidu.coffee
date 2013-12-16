_ = require('underscore')
request = require('request')
crypto = require('crypto')

class BaiduPlatform

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

  send: (data, callback = -> ) ->
    console.log 'Baidu sender'
    callback(null, data)

  sign: (method, url, params, secret) ->
    params = ksort(params)
    paramsStr = ("#{k}=#{v}" for k, v of params).join('')
    rawStr = urlencode("#{method}#{url}#{paramsStr}#{secret}")
    crypto.createHash('md5').update(rawStr).digest('hex')

  pushMsg: (data, callback = ->) ->
    url = 'http://channel.api.duapp.com/rest/2.0/channel/channel'
    method = 'POST'
    {secret} = data
    delete data.secret
    data.sign = @sign(method, url, data, secret)
    request
      uri: url
      method: method
      form: data
    , (err, res, body) ->
      return callback(err, body)

baidu = new BaiduPlatform
baidu.BaiduPlatform = BaiduPlatform
module.exports = baidu
