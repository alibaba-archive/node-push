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
  luosimao: {
    user: 'username'
    apiKey: 'apiKey'
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
pusher.luosimao.send({
  mobile: 1111111111
  message: '夏季炎热，注意防暑降温'
}, (err, resp) ->
  console.log err, resp
})

pusher.xiaomi.send({
  description: "发送内容"
  pass_through: 1
  payload: "urlencode％20内容"
  registration_id: 'xiaomi token'
  title: 'today'
  notify_type: 2
  extra: # 额外的数据，key 的用"extra." 开头
    "extra._objectId": "d2ewed4r"
    "extra.objectType": 'reminder'
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
