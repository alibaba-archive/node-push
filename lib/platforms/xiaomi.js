// Generated by CoffeeScript 1.8.0
(function() {
  var XiaomiPlatform, qs, request;

  request = require('request');

  qs = require('qs');

  XiaomiPlatform = (function() {
    XiaomiPlatform.prototype.send_uri = 'https://api.xmpush.xiaomi.com/v2/message/regid';

    XiaomiPlatform.prototype.method = 'POST';

    function XiaomiPlatform() {
      this.apiKey = '';
      this.apiSecret = '';
    }

    XiaomiPlatform.prototype.configure = function(options) {
      var key, val, _results;
      if (options == null) {
        options = {};
      }
      _results = [];
      for (key in options) {
        val = options[key];
        _results.push(this[key] = val);
      }
      return _results;
    };

    XiaomiPlatform.prototype.send = function(data, callback) {
      var self, uri;
      if (data == null) {
        data = {};
      }
      self = this;
      uri = self.send_uri + '?' + qs.stringify(data);
      return request({
        uri: self.send_uri,
        method: self.method,
        json: true,
        headers: {
          Authorization: "key=" + self.apiSecret
        }
      }, function(err, res, body) {
        return callback(err, body);
      });
    };

    return XiaomiPlatform;

  })();

  module.exports = new XiaomiPlatform;

}).call(this);