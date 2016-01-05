EventEmitter = require('events').EventEmitter

class Pusher extends EventEmitter
  configure: (options) ->
    for serv, conf of options
      @[serv] = require("./platforms/#{serv}").configure(conf)
      @[serv].on('error', (error) => @emit('error', error))
    return @
module.exports = new Pusher
