/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const { EventEmitter } = require('events')
const request = require('request')
const httpsAgent = new (require('https').Agent)({keepAlive: true})

const defaultOptions = {
  apiUrl: 'api.mailgun.net',
  apiKey: '',
  domain: ''
}
// _ Example _
//  mailgun.send({
//    from: 'SKY <sky@leeqiang.mailgun.org>'
//    to: 'qiang@teambition.com'
//    subject: 'Hello, qiang'
//    html: '<h1>Qiang, 您好</h1>'
//    text: 'Qiang, 您好'
//  })
class Mailgun extends EventEmitter {
  constructor () {
    super(...arguments)
    this.options = Object.create(defaultOptions)
  }

  configure (options = {}) {
    for (let key in options) {
      const val = options[key]
      this.options[key] = val
    }
    return this
  }

  //  - data
  //    from:
  //    to:
  //    subject:
  //    html:
  //    text:
  //  - callback: (err, ret) ->
  send (data, callback) {
    if (!this.options.domain) { return this.emit('error', new Error('domain is required')) }
    const api = `https://${this.options.apiUrl}/v2/${this.options.domain}/messages`
    return this.request(api, data, callback)
  }

  callback (err) {
    if (err) { return this.emit('error', err) }
  }

  addSubscribe (listAddress, data = {}, callback) {
    const api = `https://${this.options.apiUrl}/v2/lists/${listAddress}/members`
    data.method = 'POST'
    return this.request(api, data, callback)
  }

  // Deprecated
  updateSubscribe (listAddress, data = {}, callback) {
    const api = `https://${this.options.apiUrl}/v2/lists/${listAddress}/members/${data.address}`
    data.method = 'PUT'
    return this.request(api, data, callback)
  }

  deleteSubscribe (listAddress, data = {}, callback) {
    const api = `https://${this.options.apiUrl}/v2/lists/${listAddress}/members/${data.address}`
    data.method = 'DELETE'
    return this.request(api, data, callback)
  }

  request (api, data, callback) {
    if (typeof callback !== 'function') { callback = this.callback.bind(this) }
    if (!this.options.apiKey) { return callback(new Error('apiKey is required')) }

    request({
      url: api,
      method: data.method || 'POST',
      auth: `api:${this.options.apiKey}`,
      data,
      httpsAgent
    }
      , function (err, body, resp) {
      try {
        body = JSON.parse(body)
        if (resp.statusCode !== 200) {
          if (!err) { err = new Error(body.error || body.message || body) }
        }
      } catch (e) {
        if (!err) { err = e }
      }
      callback(err, body)
    })
  }
}

const mailgun = new Mailgun()
mailgun.Mailgun = Mailgun
module.exports = mailgun
