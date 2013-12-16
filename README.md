node-push
======

Pushfication written in Nodejs


# How to use

```
pusher = require('node-push')

pusher.configure({
  apn: {
    cert: 'cert.pem'
    key: 'key.pem'
    expiry: 3600 # seconds
    sound: 'ping.aiff'
    useSandbox: false
  }
  baidu: {}
  mailgun: {
    domain: 'leeqiang.mailgun.org'
    apiKey: 'key-1ujk-u1o62lqe4933g3he9ht09f1e0i3'
  }
})

pusher.mailgun.send({
  from: 'SKY <sky@leeqiang.mailgun.org>'
  to: 'qiang@teambition.com'
  subject: 'test'
  html: 'html'
  text: 'text'
  'o:testmode': true
}, (err, ret) ->
  console.log err, ret
)

pusher.apn.send({
  deviceToken: 'xxxx'
  alert: 'new message'
  badge: 1
  sound: 'ping.aiff'
  extra: {}
})
pusher.baidu.send()

```