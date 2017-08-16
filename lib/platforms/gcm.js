const request = require('request')
const Sock5Agent = require('socks5-https-client/lib/Agent')
const { EventEmitter } = require('events')
const { Agent } = require('https')

const gcmUrl = 'https://gcm-http.googleapis.com/gcm/send'

class GCM extends EventEmitter {
  constructor () {
    super()
    this.options = {}
  }

  configure (options = {}) {
    for (let key in options) {
      let val = options[key]
      this.options[key] = val
    }
    if (this.options.use_proxy) {
      this.agent = new Sock5Agent({
        socksHost: this.options.ss_proxy_host || 'localhost',
        socksPort: this.options.ss_proxy_port || 1080
      })
    } else {
      this.agent = new Agent()
    }
    return this
  }

  send (data = {}) {
    let self = this
    return request({
      url: gcmUrl,
      agent: this.agent,
      method: 'post',
      headers: {
        Authorization: `key=${this.options.apiKey}`,
        'Content-Type': 'application/json'
      },
      json: true,
      body: data
    }, function (err, resp, body) {
      if (err) return self.emit(err)
      if (body.error) return self.emit(new Error(body.error))
      if (resp.status >= 300) return self.emit(new Error(body))
      if (body.results && Array.isArray(body.results)) {
        body.results.map(function (result, i) {
          if (!data.to && !data.registration_ids) return
          let regId = data.to || (data.registration_ids != null ? data.registration_ids[i] : undefined)
          if (result.error) self.emit('invalid device', regId)
        })
      }
    })
  }
}

let gcm = new GCM()
gcm.GCM = GCM
module.exports = gcm
