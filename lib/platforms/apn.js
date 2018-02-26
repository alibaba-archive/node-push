/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const apn = require('apn')
const { EventEmitter } = require('events')

const defaultOptions = {
  useSandbox: false,
  expiry: 3600, // 1 hour
  sound: 'ping.aiff',
  slient: false,
  maxConnections: 5
}

class ApplePushNotification extends EventEmitter {
  constructor () {
    super(...arguments)
    this.options = Object.create(defaultOptions)
  }

  configure (options = {}) {
    for (let key in options) {
      const val = options[key]
      this.options[key] = val
    }
    const connectionOptions = {
      cert: this.options.cert,
      key: this.options.key,
      pfx: this.options.pfx,
      passphrase: this.options.passphrase,
      production: !this.options.useSandbox,
      maxConnections: this.options.maxConnections
    }
    this.connection = new apn.Connection(connectionOptions)
    this.connection.on('transmissionError', (errCode, notification, device) => {
      const error = new Error(`transmissionError ${errCode}`)
      error.notification = notification
      error.device = device.toString()
      this.emit('error', error)
    })
    this.connection.on('error', error => this.emit('error', error))
    return this
  }

  getInvalidDevices (callback) {
    const connectionOptions = {
      cert: this.options.cert,
      key: this.options.key,
      pfx: this.options.pfx,
      passphrase: this.options.passphrase,
      production: !this.options.useSandbox,
      maxConnections: this.options.maxConnections
    }
    const feedback = new apn.Feedback(connectionOptions)
    feedback.once('error', callback)
    feedback.on('feedback', rows =>
      callback(null, rows.map(row => row.device.toString()))
    )
  }

  send (data = {}) {
    if (!(data != null ? data.deviceToken : undefined)) {
      const err = new Error('device token is required')
      err.data = data
      return this.emit('error', err)
    }

    const myDevice = new apn.Device(data.deviceToken)
    const note = new apn.Notification()

    note.badge = data.badge
    note.category = data.category
    note.expiry = Math.floor(Date.now() / 1000) + this.options.expiry
    if (data.hasOwnProperty('sound')) {
      note.sound = data.sound
    } else {
      note.sound = this.options.sound
    }
    note.alert = data.alert
    if (data.extra) {
      note.payload = data.extra
    }

    if (data.contentAvailable) {
      note.contentAvailable = 1
    }

    if (data.slient || this.options.slient) {
      note.sound = ''
    }

    this.connection.pushNotification(note, myDevice)
  }
}

const applePN = new ApplePushNotification()
applePN.ApplePushNotification = ApplePushNotification
module.exports = applePN
