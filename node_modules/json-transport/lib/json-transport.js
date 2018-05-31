var url = require('url')

module.exports = function (server, options) {
  options = (options !== null && options !== undefined && options.constructor === Object) ? options : {}
  options.indent = (typeof options.indent !== 'string' && options.indent !== false) ? '   ' : options.indent
  options.domain = !options.domain || typeof options.domain !== 'string' ? '.default.lan' : options.domain
  options.standardHeaders = options.standardHeaders ? options.standardHeaders : {}
  options.standardHeaders['access-control-allow-origin'] = options.standardHeaders['access-control-allow-origin'] || '*' + options.domain
  options.standardHeaders['access-control-allow-headers'] = options.standardHeaders['access-control-allow-headers'] || 'X-Requested-With'

  var iframeHtmlTemplate = [
    '<!doctype html><html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"/><script type="text/javascript">document.domain = "' + options.domain + '";parent.',
    '(',
    ')</script></head><body></body></html>'
  ]

  return function (request, response, next) {
    response.serveJSON = serveResponse.bind(null, request, response)
    response.streamJSON = startResponseStream.bind(null, request, response)
    next && next()
  }

  function normalizeParams (params) {
    params = params || {}
    params.headers = params.headers || {}
    params.httpStatusCode = isNaN(params.httpStatusCode) ? 200 : params.httpStatusCode
    params.httpStatusMessage = params.httpStatusMessage || ''
    return params;
  }

  function serveResponse(request, response, json, params) {
    params = normalizeParams(params)

    if (json !== undefined) {
      if (request.querystring.callback) {
        if (request.method === 'POST') {
          params.headers['content-type'] = 'text/html'
          json = iframeHtmlTemplate[0] + request.querystring.callback + iframeHtmlTemplate[1] + JSON.stringify(json) + iframeHtmlTemplate[2]
        } else {
          params.headers['content-type'] = 'text/javascript'
          json = request.querystring.callback + '(' + JSON.stringify(json, null, options.indentationString) + ')'
        }
        // JSON parse vs eval fix. https://github.com/rack/rack-contrib/pull/37
        json = json.replace(/\u2028/g, '\\u2028').replace(/\u2029/g, '\\u2029')
      } else {
        params.headers['content-type'] = 'application/json'
        json = JSON.stringify(json, null, options.indentationString)
      }
      params.headers['content-length'] = Buffer.byteLength(json, 'utf8')
    }

    fillObject(params.headers, options.standardHeaders)
    params.headers['content-type'] += '; charset=UTF-8'

    response.writeHead(params.httpStatusCode, params.httpStatusMessage, params.headers)
    response.end(json, 'utf8')
  }

  function startResponseStream(request, response, json, params) {
    params = normalizeParams(params)
    response.streamJSON = writeResponseStream.bind(null, request, response)

    if (request.querystring.callback) {
      if (request.method === 'POST') {
        params.headers['content-type'] = 'text/html'
        response.streamStartChunk = iframeHtmlTemplate[0] + request.querystring.callback + iframeHtmlTemplate[1] + '['
        response.streamEndChunk = ']' + iframeHtmlTemplate[2]
      } else {
        params.headers['content-type'] = 'text/javascript'
        response.streamStartChunk = request.querystring.callback + '(['
        response.streamEndChunk = '])'
      }
    } else {
      params.headers['content-type'] = 'text/javascript'
      response.streamStartChunk = '['
      response.streamEndChunk = ']'
    }

    fillObject(params.headers, options.standardHeaders)

    params.headers['content-type'] += '; charset=UTF-8'

    response.writeHead(params.httpStatusCode, params.httpStatusMessage, params.headers)
    response.write(response.streamStartChunk, 'utf8')

    if (json === undefined) {
      response.end(response.streamEndChunk, 'utf8')
    } else {
      response.lastResponseChunk = json
    }

    delete response.streamStartChunk
  }

  function writeResponseStream(request, response, json) {
    var responseChunk = JSON.stringify(response.lastResponseChunk, null, options.indentationString)
    // JSON parse vs eval fix. https://github.com/rack/rack-contrib/pull/37
    if (request.querystring.callback) {
      responseChunk = responseChunk.replace(/\u2028/g, '\\u2028').replace(/\u2029/g, '\\u2029')
    }
    if (json !== undefined) {
      responseChunk += ',\n'
      response.write(responseChunk, 'utf8')
      response.lastResponseChunk = json
    } else {
      response.write(responseChunk, 'utf8')
      response.end(response.streamEndChunk, 'utf8')
    }
  }
}

function fillObject (targetObj, fillObj) {
  Object.keys(fillObj).forEach(function (key) {
    if (!targetObj.hasOwnProperty(key)) {
      targetObj[key] = fillObj[key]
    }
  })
}