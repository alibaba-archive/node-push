/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const request = require('request')
const Sock5Agent = require('socks5-https-client/lib/Agent')
const { EventEmitter } = require('events')
const { Agent } = require('https')

const gcmUrl = 'https://gcm-http.googleapis.com/gcm/send'
const defaultOptions = {}

class GCM extends EventEmitter {
  constructor () {
    super(...arguments)
    this.options = Object.create(defaultOptions)
  }

  configure (options = {}) {
    for (let key in options) {
      const val = options[key]
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
    const self = this
    request(
      {
        url: gcmUrl,
        httpsAgent: this.agent,
        method: 'POST',
        headers: {
          Authorization: `key=${this.options.apiKey}`
        },
        json: true,
        data
      },
      function (err, resp, body) {
        if (err) {
          return self.emit(err)
        }
        if (body.error) {
          return self.emit(new Error(body.error))
        }
        if (resp.status >= 300) {
          return self.emit(new Error(body))
        }
        if (body.results && Array.isArray(body.results)) {
          body.results.map(function (ele, i) {
            if (!data.to && !data.registration_ids) {
              return
            }

            const regId =
              data.to ||
              (data.registration_ids != null
                ? data.registration_ids[i]
                : undefined)
            if (ele.error) {
              return self.emit('invalid device', regId)
            }
          })
        }
      }
    )
  }
}

const gcm = new GCM()
gcm.GCM = GCM
module.exports = gcm
