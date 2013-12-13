
_ = require('underscore')
utils = require('./utils')

class Pusher

  configure: (options) ->

    paths = utils.findBackendPathByServName(_.keys(options))

    for serv, conf of options
      if paths[serv]
        push[serv] = require("./#{paths[serv]}").configure(conf)
    return push


push = new Pusher
exports = module.exports = push
