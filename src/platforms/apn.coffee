apns = require('apn')

class ApplePushNotification

  sandbox_gateway = 'gateway.sandbox.push.apple.com'
  gateway = 'gateway.push.apple.com'

  useSandbox: false
  expiry: 3600 # 1 hour
  sound: 'ping.aiff'

  constructor: ->
    @key = 'cert.pem'
    @cert = 'key.pem'

  configure: (options = {}) ->
    for key, val of options
      @[key] = val
    return @

  callback: (err, notice) ->
    console.error("APN-ERROR: #{err}, content: #{notice.compiledPayload}") if err?

  # deviceToken
  # alert
  # badge = 1
  # extra = {}
  send: (data, callback) ->

    unless data?.deviceToken
      throw new Error('device token is required')

    data.alert or= 'new message'
    data.badge or= 1

    connection = new apns.Connection({
      cert: @cert
      key: @key
      gateway: if @useSandbox then sandbox_gateway else gateway
      errorCallback: callback or @callback
    })

    myDevice = new apns.Device(data.deviceToken)
    note = new apns.Notification()

    note.badge = data.badge
    note.expiry = Math.floor(Date.now() / 1000) + @expiry
    note.sound = @sound
    note.alert = data.alert
    note.payload = data.extra if data.extra

    connection.pushNotification(note, myDevice)

applePN = new ApplePushNotification
applePN.ApplePushNotification = ApplePushNotification
exports = module.exports = applePN
