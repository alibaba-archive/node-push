/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const request = require('request');
const qs = require('querystring');
const { EventEmitter } = require('events');
const httpsAgent = new (require('https').Agent)({keepAlive: true});

const defaultOptions = {
  apiKey: '',
  apiSecret: '',
  send_uri: 'https://api.xmpush.xiaomi.com/v2/message/regid',
  invalid_regid_uri: 'https://feedback.xmpush.xiaomi.com/v1/feedback/fetch_invalid_regids',
  method: 'POST'
};

class XiaomiPlatform extends EventEmitter {

  constructor() {
    super(...arguments);
    this.options = Object.create(defaultOptions);
  }

  getInvalidDevices(callback) {
    return request({
      url: this.options.invalid_regid_uri,
      httpsAgent,
      headers: {
        Authorization: `key=${this.options.apiSecret}`
      }
    }
    , function(err, body, res) {
      try {
        let list = [];
        body = JSON.parse(body);
        if ((body != null ? body.result : undefined) === 'error') { if (!err) { err = new Error(body.reason); } }
        ({ list } = body.data);
        return callback(err, list);
      } catch (e) {
        if (!err) { err = e; }
        return callback(err, body);
      }
    });
  }

  configure(options = {}) {
    for (let key in options) {
      const val = options[key];
      this.options[key] = val;
    }
    return this;
  }

  send(data = {}) {
    const { extra } = data;
    delete data.extra;

    const uri = this.options.send_uri + '?' + qs.stringify(data);
    return request({
      url: uri,
      method: this.options.method,
      contentType: 'json',
      data: extra,
      httpsAgent,
      headers: {
        Authorization: `key=${this.options.apiSecret}`
      }
    }
    , (err, body, res) => {
      try {
        body = JSON.parse(body);
        if (body.result === 'error') { if (!err) { err = new Error(body.reason); } }
      } catch (e) {
        if (!err) { err = e; }
      }
      if (err) { return this.emit('error', err); }
    });
  }
}

module.exports = new XiaomiPlatform;
