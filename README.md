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
  baidu: {
    secret: 'your app secret'
  }
  mailgun: {
    domain: 'your-domian.mailgun.org'
    apiKey: 'appkey'
  }
})

pusher.mailgun.send({
  from: 'SKY <sky@your-domain.mailgun.org>'
  to: 'xxx@your-domain.com'
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
pusher.baidu.send({
  messages: JSON.stringify
    title: 'title'
    description: 'desc'
    custom_content:
      badge: 1
  user_id: 'user_id'
})

```

# others
``` mailgun subscribe
pusher.mailgun.subscribe(`listAddress`, {
  subscribed: true
  address: 'your@exmaple.com'
  name: 'yourname'
  description: 'your info'
}, (err, ret) ->
  console.log err, ret
)
```
