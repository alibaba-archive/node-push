const { EventEmitter } = require('events')
const MailgunServ = require('mailgun-js')

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
    super()
    this.options = { apiKey: '', domain: '' }
  }

  configure (options = {}) {
    for (let key in options) {
      let val = options[key]
      this.options[key] = val
    }
    this.mailgun = new MailgunServ({
      apiKey: this.options.apiKey,
      domain: this.options.domain
    })
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
    return this.mailgun.messages().send(data, callback)
  }

  callback (err) {
    if (err) return this.emit('error', err)
  }

  addSubscribe (listAddress, data, callback) {
    if (data == null) data = {}
    let list = this.mailgun.lists(listAddress)
    return list.members().create(data, callback)
  }

  // Deprecated
  updateSubscribe (listAddress, data, callback) {
    if (data == null) data = {}
    let list = this.mailgun.lists(listAddress)
    return list.members(data.address).update(data, callback)
  }

  deleteSubscribe (listAddress, data, callback) {
    if (data == null) data = {}
    let list = this.mailgun.lists(listAddress)
    return list.members(data.address).delete(callback)
  }
}

let mailgun = new Mailgun()
mailgun.Mailgun = Mailgun
module.exports = mailgun
