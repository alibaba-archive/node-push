crypto = require('crypto')

class BaiduPlatform

  urlencode = (str) ->
    encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28')
    .replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+')

  sign: (method, url, params, secret) ->
    paramsStr = ("#{k}=#{v}" for k, v of params).join('')
    rawStr = urlencode("#{method}#{url}#{paramsStr}#{secret}")
    crypto.createHash('md5').update(rawStr).digest('hex')

module.exports = BaiduPlatform
