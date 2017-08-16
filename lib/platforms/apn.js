const apns = require('apn')
const { EventEmitter } = require('events')

let defaultOptions = {
  useSandbox: false,
  expiry: 3600, // 1 hour
  sound: 'ping.aiff',
  slient: false,
  maxConnections: 5
}

class ApplePushNotification extends EventEmitter {
  constructor () {
    super()
    this.options = Object.create(defaultOptions)
  }

  configure (options = {}) {
    for (let key in options) {
      let val = options[key]
      this.options[key] = val
    }
    let connectionOptions = {
      cert: this.options.cert,
      key: this.options.key,
      pfx: this.options.pfx,
      passphrase: this.options.passphrase,
      production: !this.options.useSandbox,
      maxConnections: this.options.maxConnections
    }
    this.connection = new apns.Connection(connectionOptions)
    this.connection.on('transmissionError', (errCode, notification, device) => {
      let error = new Error(`transmissionError ${errCode}`)
      error.notification = notification
      error.device = device.toString()
      return this.emit('error', error)
    })
    this.connection.on('error', error => this.emit('error', error))
    return this
  }

  getInvalidDevices (callback) {
    let connectionOptions = {
      cert: this.options.cert,
      key: this.options.key,
      pfx: this.options.pfx,
      passphrase: this.options.passphrase,
      production: !this.options.useSandbox,
      maxConnections: this.options.maxConnections
    }
    let feedback = new apns.Feedback(connectionOptions)
    feedback.once('error', callback)
    feedback.on('feedback', rows => callback(null, rows.map(row => row.device.toString())))
  }

  send (data = {}) {
    if (!data.deviceToken) {
      throw new Error('device token is required')
    }

    let myDevice = new apns.Device(data.deviceToken)
    let note = new apns.Notification()

    note.badge = data.badge
    note.category = data.category
    note.expiry = Math.floor(Date.now() / 1000) + this.options.expiry
    if (data.hasOwnProperty('sound')) {
      note.sound = data.sound
    } else {
      note.sound = this.options.sound
    }
    note.alert = data.alert
    if (data.extra) note.payload = data.extra

    if (data.slient || this.options.slient) {
      note.sound = ''
      note['content-available'] = 1
    }
    return this.connection.pushNotification(note, myDevice)
  }
}

let applePN = new ApplePushNotification()
applePN.ApplePushNotification = ApplePushNotification
module.exports = applePN
