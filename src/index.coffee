
_ = require('underscore')

class Pusher

  configure: (options) ->

    for serv, conf of options
      try
        push[serv] = require("./platforms/#{serv}").configure(conf)
      catch e
    return push

push = new Pusher
exports = module.exports = push
