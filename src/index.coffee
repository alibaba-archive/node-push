_ = require('underscore')
EventEmitter = require('events').EventEmitter

class Pusher extends EventEmitter
  configure: (options) ->
    for serv, conf of options
      @[serv] = require("./platforms/#{serv}").configure(conf)
      @[serv].on('error', @onerror.bind(@))
    return @
  onerror: (err, source) ->
    err.source = source
    @emit('error', err)

module.exports = new Pusher
