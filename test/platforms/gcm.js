/* global describe, it */
const assert = require('assert')
const config = require('../private/config')
const pusher = require('../../lib/')

pusher.configure(config)

describe('push#units/platforms/gcm', function () {
  describe('gcm@push', function () {
    it('should get the correct without error', function (done) {
      let params = {
        to: 'd5qC2izz3BQ:APA91bHdzZoXMGgOOx7vAAjavavS4jgA1RdlG6vfnjr5RArxj1GBLXaGpYo-I64yeNAMc3ADH-m9qghPkWS_9Ih5GVUG74YjKo9lpNVkygmNA_T8kZ5VZUF-RwBvnE7opr5ptO603DDV',
        data: {
          message: 'hello world'
        }
      }
      pusher.gcm.send(params)
      setTimeout(done, 5000)
    })
  })

  describe('gcm push invalid device token', function () {
    it('should get the correct without error', function (done) {
      let params = {
        to: 'abcdefg',
        data: {
          message: 'hello world'
        }
      }
      pusher.gcm.send(params)
      pusher.gcm.on('invalid device', function (device) {
        assert.equal(device, params.to)
        done()
      })
    })
  })
})
