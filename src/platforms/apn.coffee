apns = require('apn')
EventEmitter = require('events').EventEmitter

class ApplePushNotification extends EventEmitter

  sandbox_gateway = 'gateway.sandbox.push.apple.com'
  gateway = 'gateway.push.apple.com'

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
      @[key] = val
    @connection = new apns.Connection({
      cert: @cert
      key: @key
      gateway: if @useSandbox then sandbox_gateway else gateway
      maxConnections: @maxConnections
      errorCallback: (error, notice) -> 
        error.notice = notice
        self.emit 'error', error
    })
    return @

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
