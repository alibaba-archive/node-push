should = require 'should'
pusher = require '../../../src'
config = require('../../private/config')

describe 'push#units/platforms/luosimao', ->

  pusher.configure(config)

  postData =
    mobile: 11111111111
    message: '夏季炎热，注意防暑降温'

  describe 'luosimao#send', ->
    it 'should return error', (done) ->
      pusher.luosimao.send postData, (err, resp) ->
        resp.should.have.property('error')
        resp.should.have.property('msg')
        done()

  describe 'luosimao#status', ->
    it 'should return deposite', (done) ->
      pusher.luosimao.status (err, resp) ->
        resp.should.have.property('error', 0)
        resp.should.have.property('deposit')
        done()