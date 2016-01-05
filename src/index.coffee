_ = require('underscore')
EventEmitter = require('events').EventEmitter

class Pusher extends EventEmitter
  configure: (options) ->
  	self = @
    for serv, conf of options
      @[serv] = require("./platforms/#{serv}").configure(conf)
      @[serv].on('error', (error) -> self.emit('error', error))
    return @
module.exports = new Pusher
