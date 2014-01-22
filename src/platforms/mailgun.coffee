
request = require('request')

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
    console.error("MAILGUN-ERROR: ", err, res) if err?

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

    unless @domain
      throw new Error("domain is required")

    api = "https://#{@apiUrl}/v2/#{@domain}/messages"
    @request(api, data, callback)


  subscribe: (listAddress, data = {}, callback = ->) ->
    #    'subscribed': True,
    #    'address': self.email,
    #    'name': self.name,
    #    'description': self.description,

    api = "https://#{@apiUrl}/v2/lists/#{listAddress}/members"
    @request(api, data, callback)


  request: (api, data, callback) ->

    unless @apiKey
      throw new Error("apiKey is required")

    request {
      method: 'post'
      url: api
      auth:
        user: "api:#{ @apiKey }"
      form: data
    }, (err, resp, ret) ->

      try
        ret = JSON.parse(ret)
      catch e
        err or= e
      callback(err, ret)


mailgun = new Mailgun
mailgun.Mailgun = Mailgun
exports = module.exports = mailgun
