var should = require('should'),
    Stream = require('stream'),
    jsonreq = require('request').defaults({ json: true }),
    ApiServer = require('apiserver'),
    JSONTransport = require('../'),
    testModule = require('./fixtures/json-transport-module')

var jsonTransport
var apiserver
var defaultPort = 9000
var customPort = 8080

describe('JSONTransport()', function () {
  before(function (done) {
    apiserver = new ApiServer()
    apiserver.addModule('v1', 'test', testModule)
    apiserver.listen(defaultPort, done)
  })
  after(function () {
    apiserver.close()
  })
  it('should normalize options', function () {
    var options = {}
    JSONTransport(null, options)
    options.should.have.property('indent')
    options.indent.should.be.equal('   ')
    options.domain.should.be.equal('.default.lan')
    options.standardHeaders.should.be.eql({
      'access-control-allow-origin': '*.default.lan',
      'access-control-allow-headers': 'X-Requested-With'
    })
  })
  it('should normalize the indent option', function () {
    [{},[],487,null].forEach(function (val) {
      var options = { indent: val }
      JSONTransport(null, options)
      options.indent.should.be.equal('   ')
    })
  })
  it('should normalize the domain option', function () {
    [-10, NaN, null, {}, []].forEach(function (val) {
      var options = { domain: val }
      JSONTransport(null, options)
      options.domain.should.be.equal('.default.lan')
    })
  })
  it('should add methods to the response object', function (done) {
    var methods = ['serveJSON','streamJSON'];
    jsonreq.get('http://localhost:' + defaultPort + '/v1/test/check_response?m=' + methods.join(','), function (err, response, body) {
      methods.forEach(function (methodName) {
        body.should.have.property(methodName)
        body[methodName].should.be.equal('function')
      })
      done(err)
    })
  })
})
describe('serveJSON()', function () {
  before(function (done) {
    apiserver = new ApiServer()
    apiserver.addModule('v1', 'test', testModule)
    apiserver.listen(defaultPort, done)
  })
  after(function () {
    apiserver.close()
  })
  it('should merge custom and default headers', function (done) {
    jsonreq.get('http://localhost:' + defaultPort + '/v1/test/check_overridings', function (err, response, body) {
      response.headers.should.have.property('x-server')
      response.headers['x-server'].should.be.equal('bar server')
      response.headers.should.have.property('x-foo')
      response.headers['x-foo'].should.be.equal('bar')
      response.headers.should.have.property('content-type')
      response.headers['content-type'].should.be.equal('application/json; charset=UTF-8')
      done(err)
    })
  })
  it('should use custom http codes/message', function (done) {
    jsonreq.get('http://localhost:' + defaultPort + '/v1/test/check_overridings', function (err, response, body) {
      response.statusCode.should.be.equal(201)
      //response.statusMessage.should.be.equal(201) // REALLY?
      done(err)
    })
  })
  it('should switch to JSONP with the callback parameter', function (done) {
    jsonreq.get('http://localhost:' + defaultPort + '/v1/test/jsonp?callback=cb', function (err, response, body) {
      body.should.be.eql('cb({})')
      response.headers.should.have.property('content-type')
      response.headers['content-type'].should.be.equal('text/javascript; charset=UTF-8')
      done(err)
    })
  })
  it('should switch to JSONP+iFrame when POST with the callback parameter', function (done) {
    jsonreq.post('http://localhost:' + defaultPort + '/v1/test/jsonp?callback=cb', function (err, response, body) {
      body.should.be.eql('<!doctype html><html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"/><script type="text/javascript">' +
                         'document.domain = ".default.lan";parent.cb({})</script></head><body></body></html>')
      response.headers.should.have.property('content-type')
      response.headers['content-type'].should.be.equal('text/html; charset=UTF-8')
      done(err)
    })
  })
  it('should escape \\u2028 and \\u2029', function (done) {
    jsonreq.post('http://localhost:' + defaultPort + '/v1/test/jsonp_escape?callback=cb', function (err, response, body) {
      body.should.be.eql('<!doctype html><html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"/><script type="text/javascript">' +
                         'document.domain = ".default.lan";parent.cb("\\u2028\\u2029")</script></head><body></body></html>')
      done(err)
    })
  })
})
describe('streamJSON()', function () {
  before(function (done) {
    apiserver = new ApiServer()
    apiserver.addModule('v1', 'test', testModule)
    apiserver.listen(defaultPort, done)
  })
  after(function () {
    apiserver.close()
  })
  it('should stream correctly JSON', function (done) {
    jsonreq.post('http://localhost:' + defaultPort + '/v1/test/stream', function (err, response, body) {
      body.should.eql(['first','second','third'])
      done(err)
    }).once('data', function (chunk) {
      chunk.toString('utf8').should.be.equal('[')
      this.once('data', function (chunk) {
        chunk.toString('utf8').should.be.equal('"first",\n')
        this.once('data', function (chunk) {
          chunk.toString('utf8').should.be.equal('"second",\n')
          this.once('data', function (chunk) {
            chunk.toString('utf8').should.be.equal('"third"')
            this.once('data', function (chunk) {
              chunk.toString('utf8').should.be.equal(']')
            })
          })
        })
      })
    })
  })
  it('should switch to JSONP when GET with the callback parameter', function (done) {
    jsonreq.get('http://localhost:' + defaultPort + '/v1/test/stream?callback=cb', function (err, response, body) {
      body.should.eql('cb(["first",\n"second",\n"third"])')
      done(err)
    }).once('data', function (chunk) {
      chunk.toString('utf8').should.be.equal('cb([')
      this.once('data', function (chunk) {
        chunk.toString('utf8').should.be.equal('"first",\n')
        this.once('data', function (chunk) {
          chunk.toString('utf8').should.be.equal('"second",\n')
          this.once('data', function (chunk) {
            chunk.toString('utf8').should.be.equal('"third"')
            this.once('data', function (chunk) {
              chunk.toString('utf8').should.be.equal('])')
            })
          })
        })
      })
    })
  })
  it('should switch to JSONP+iFrame when POST with the callback parameter', function (done) {
    jsonreq.post('http://localhost:' + defaultPort + '/v1/test/stream?callback=cb', function (err, response, body) {
      body.should.be.eql('<!doctype html><html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"/><script type="text/javascript">' +
                         'document.domain = ".default.lan";parent.cb(["first",\n"second",\n"third"])</script></head><body></body></html>')
      done(err)
    }).once('data', function (chunk) {
      chunk.toString('utf8').should.be.equal('<!doctype html><html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"/><script type="text/javascript">' + 
                                             'document.domain = ".default.lan";parent.cb([')
      this.once('data', function (chunk) {
        chunk.toString('utf8').should.be.equal('"first",\n')
        this.once('data', function (chunk) {
          chunk.toString('utf8').should.be.equal('"second",\n')
          this.once('data', function (chunk) {
            chunk.toString('utf8').should.be.equal('"third"')
            this.once('data', function (chunk) {
              chunk.toString('utf8').should.be.equal('])</script></head><body></body></html>')
            })
          })
        })
      })
    })
  })
  describe('should end on first call if no json is provided', function () {
    it('JSON', function (done) {
      jsonreq.get('http://localhost:' + defaultPort + '/v1/test/stream_single', function (err, response, body) {
        body.should.eql([])
        done(err)
      }).once('data', function (chunk) {
        chunk.toString('utf8').should.be.equal('[')
        this.once('data', function (chunk) {
          chunk.toString('utf8').should.be.equal(']')
        })
      })
    })
    it('JSONP', function (done) {
      jsonreq.get('http://localhost:' + defaultPort + '/v1/test/stream_single?callback=cb', function (err, response, body) {
        body.should.eql('cb([])')
        done(err)
      }).once('data', function (chunk) {
        chunk.toString('utf8').should.be.equal('cb([')
        this.once('data', function (chunk) {
          chunk.toString('utf8').should.be.equal('])')
        })
      })
    })
    it('JSONP+iFrame', function (done) {
      jsonreq.post('http://localhost:' + defaultPort + '/v1/test/stream_single?callback=cb', function (err, response, body) {
        body.should.be.eql('<!doctype html><html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"/><script type="text/javascript">' +
                           'document.domain = ".default.lan";parent.cb([])</script></head><body></body></html>')
        done(err)
      })
    })
  })
})