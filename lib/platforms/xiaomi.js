const request = require('request')
const qs = require('querystring')
const { EventEmitter } = require('events')

let defaultOptions = {
  apiKey: '',
  apiSecret: '',
  send_uri: 'https://api.xmpush.xiaomi.com/v2/message/regid',
  invalid_regid_uri: 'https://feedback.xmpush.xiaomi.com/v1/feedback/fetch_invalid_regids',
  method: 'POST'
}

class XiaomiPlatform extends EventEmitter {
  constructor () {
    super()
    this.options = Object.create(defaultOptions)
  }

  getInvalidDevices (callback) {
    return request({
      url: this.options.invalid_regid_uri,
      forever: true,
      headers: {
        Authorization: `key=${this.options.apiSecret}`
      }
    }, function (err, res, body) {
      try {
        body = JSON.parse(body)
        if (body && body.result === 'error') err = new Error(body.reason)
        return callback(err, body.data.list)
      } catch (e) {
        if (!err) err = e
        return callback(err, body)
      }
    })
  }

  configure (options = {}) {
    for (let key in options) {
      let val = options[key]
      this.options[key] = val
    }
    return this
  }

  send (data = {}) {
    let { extra } = data
    delete data.extra

    let uri = this.options.send_uri + '?' + qs.stringify(data)
    return request({
      url: uri,
      method: this.options.method,
      body: extra,
      forever: true,
      headers: {
        Authorization: `key=${this.options.apiSecret}`,
        'Content-Type': 'application/json'
      }
    }, (err, res, body) => {
      try {
        body = JSON.parse(body)
        if (body && body.result === 'error') err = new Error(body.reason)
      } catch (e) {
        if (!err) err = e
      }
      if (err) this.emit('error', err)
    })
  }
}

module.exports = new XiaomiPlatform()
