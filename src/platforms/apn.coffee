apns = require('apn')
EventEmitter = require('events').EventEmitter

class ApplePushNotification extends EventEmitter

  options:
    key: 'cert.pem'
    cert: 'key.pem'
    useSandbox: false
    expiry: 3600 # 1 hour
    sound: 'ping.aiff'
    slient: false
    maxConnections: 5

  configure: (options = {}) ->
    self = @
    for key, val of options
      @options[key] = val
    connectionOptions =
      cert: @options.cert
      key: @options.key
      production: !@options.useSandbox
      maxConnections: @options.maxConnections
    @connection = new apns.Connection connectionOptions
    @connection.on('error', (error) => @emit('error', error))
    return @

  getInvalidDevices: (callback = ->) ->
    connectionOptions =
      cert: @options.cert
      key: @options.key
      production: !@options.useSandbox
      maxConnections: @options.maxConnections
    feedback = new apns.Feedback connectionOptions
    feedback.on('error', (error) -> callback(error))
    feedback.on('feedback', (rows) ->
      callback(null, rows.map((row) -> row.device.toString()))
    )

  send: (data = {}) ->
    return @emit('error', new Error('device token is required')) unless data?.deviceToken

    myDevice = new apns.Device(data.deviceToken)
    note = new apns.Notification()

    note.badge = data.badge
    note.category = data.category
    note.expiry = Math.floor(Date.now() / 1000) + @options.expiry
    if data.hasOwnProperty('sound')
      note.sound = data.sound
    else note.sound = @options.sound
    note.alert = data.alert
    note.payload = data.extra if data.extra

    if data.slient or @options.slient
      note.sound = ""
      note['content-available'] = 1

    @connection.pushNotification(note, myDevice)

applePN = new ApplePushNotification
applePN.ApplePushNotification = ApplePushNotification
exports = module.exports = applePN
