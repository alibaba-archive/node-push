
pusher = require('../../../src/')


pusher.configure({
  mailgun: {
    domain: 'leeqiang.mailgun.org'
    apiKey: 'key-1ujk-u1o62lqe4933g3he9ht09f1e0i3'
  }
})

pusher.mailgun.subscribe( 'month@leeqiang.mailgun.org', {
  subscribed: true
  address: 'b@qq.com'
  name: 'b_qq'
  description: 'test'
}, (err, ret) ->
  console.log err, ret
)

pusher.mailgun.unsubscribe( 'month@leeqiang.mailgun.org', {
  subscribed: false
  address: 'b@qq.com'
  name: 'b_qq'
  description: 'test'
}, (err, ret) ->
  console.log err, ret
)