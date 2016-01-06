apns = require('apn')
EventEmitter = require('events').EventEmitter

class ApplePushNotification extends EventEmitter

  options:
    useSandbox: false
    expiry: 3600 # 1 hour
    sound: 'ping.aiff'
    slient: false
    maxConnections: 5

  constructor: ->
    @key = 'cert.pem'
    @cert = 'key.pem'

  configure: (options = {}) ->
    self = @
    for key, val of options
      @options[key] = val
    connectionOptions =
      cert: @options.cert
      key: @options.key
      production: !@useSandbox
      maxConnections: @maxConnections
    @connection = new apns.Connection connectionOptions
    @connection.on('error', (error) => @emit 'error', error)
    return @

  getInvalidDevices: (callback) ->
    connectionOptions =
      cert: @options.cert
      key: @options.key
      production: !@useSandbox
      maxConnections: @maxConnections
    feedback = new apns.Feedback connectionOptions
    feedback.on('error', (error) => @emit 'error', error)
    feedback.on('feedback', (rows) ->
      callback(null, rows.map (row)-> return row.device.toString())
    )

  send: (data = {}) ->
    return @emit('error', new Error('device token is required')) unless data?.deviceToken

    myDevice = new apns.Device(data.deviceToken)
    note = new apns.Notification()

    note.badge = data.badge
    note.category = data.category
    note.expiry = Math.floor(Date.now() / 1000) + @expiry
    if data.hasOwnProperty('sound')
      note.sound = data.sound
    else note.sound = @sound
    note.alert = data.alert
    note.payload = data.extra if data.extra

    if data.slient or @slient
      note.sound = ""
      note['content-available'] = 1

    @connection.pushNotification(note, myDevice)

applePN = new ApplePushNotification
applePN.ApplePushNotification = ApplePushNotification
exports = module.exports = applePN
