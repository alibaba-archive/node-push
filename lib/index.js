const { EventEmitter } = require('events')

class Pusher extends EventEmitter {
  configure (options) {
    for (let serv in options) {
      let conf = options[serv]
      this[serv] = require(`./platforms/${serv}`).configure(conf)
      this[serv].on('error', error => this.emit('error', error))
    }
    return this
  }
}

module.exports = new Pusher()
