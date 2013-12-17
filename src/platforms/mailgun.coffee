
qs = require('qs')
https = require('https')

# _ Example _
#  mailgun.send({
#    from: 'SKY <sky@leeqiang.mailgun.org>'
#    to: 'qiang@teambition.com'
#    subject: 'Hello, qiang'
#    html: '<h1>Qiang, 您好</h1>'
#    text: 'Qiang, 您好'
#  })
class Mailgun

  apiUrl: 'api.mailgun.net'

  constructor: ->
    @apiKey = ''
    @domain = ''

  callback: (err, res) ->
    console.error("MAILGUN-ERROR: ", err, res)

  # apiKey
  # domain
  configure: (options = {}) ->
    for key, val of options
      @[key] = val
    return @

  #  - data
  #    from:
  #    to:
  #    subject:
  #    html:
  #    text:
  #  - callback: (err, ret) ->
  send: (data, callback) ->

    callback or= @callback

    unless @apiKey
      throw new Error("apiKey is required")
    unless @domain
      throw new Error("domain is required")

    httpOptions =
      host: @apiUrl
      method: 'post'
      path: "/v2/#{@domain}/messages"
      auth: "api:#{ @apiKey }"

    body = qs.stringify(data)
    httpOptions.headers = {}

    httpOptions.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    httpOptions.headers['Content-Length'] = Buffer.byteLength(body)

    req = https.request httpOptions, (res) =>
      res.setEncoding 'utf8'
      ret = ''
      res.on 'data', (chunk) =>
        ret += chunk

      res.on 'end', =>
        callback(null, JSON.parse(ret))

    req.on 'error', (err) ->
      callback(err)

    req.end(body)

mailgun = new Mailgun
mailgun.Mailgun = Mailgun
exports = module.exports = mailgun