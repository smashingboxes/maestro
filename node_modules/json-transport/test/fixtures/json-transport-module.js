module.exports = {
  'checkResponse': function (request, response) {
    var data = Object.create(null)
    request.querystring.m.split(',').forEach(function (methodName) {
      data[methodName] = typeof response[methodName];
    })
    response.serveJSON(data)
  },
  'checkOverridings': function (request, response) {
    response.serveJSON('', {
      headers: {
        'x-server': 'bar server',
        'x-foo': 'bar'
      },
      httpStatusCode: 201,
      httpStatusMessage: 'Yeah!'
    })
  },
  'jsonp': function (request, response) {
    response.serveJSON({})
  },
  'jsonpEscape': function (request, response) {
    response.serveJSON('\u2028\u2029')
  },
  'stream': function (request, response) {
    var words = ['first','second','third']
    var fn = function () {
      if (words.length >= 1) {
        setTimeout(fn, 100);
      }
      response.streamJSON(words.shift())
    }
    fn();
  },
  'stream_single': function (request, response) {
    response.streamJSON();
  }
}