module.exports = {
  apn: {
    pfx: '/apn.p12',
    passphrase: 'your passphrase',
    expiry: 3600,
    sound: 'ping.aiff',
    useSandbox: false
  },
  xiaomi: {
    apiKey: 'your api key',
    apiSecret: 'your api secret',
    time_to_live: 3600000
  },
  gcm: {
    apiKey: 'your api key',
    use_proxy: false
  }
}
