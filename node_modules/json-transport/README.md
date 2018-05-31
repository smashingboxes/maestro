# JSONTransport [![build status](https://secure.travis-ci.org/kilianc/node-json-transport.png?branch=master)](http://travis-ci.org/kilianc/node-json-transport)

JSONTransport is the default transport for [ApiServer](https://github.com/kilianc/node-apiserver). __JSONTransport__ is the true power of __ApiServer__. It allows you to provide a JSONP API consumable by a browser both with POST and GET HTTP methods.

Multiple output wrappers are available:

* __JSON__: `application/json`
* __JSONP__: `text/javascript`
* __JSONP + iFrame__: `text/html`

The transports auto select the right wrapper based on the callback parameter presence (querystring) and the HTTP method.

![table](http://f.cl.ly/items/460B2P0h3m3c22000W1p/json-transport-0.1.0.png)

For example:

`GET http://localhost/1/test/test` will response in JSON format

`GET http://localhost/1/test/test?callback=cb` will response in JSONP format

`POST http://localhost/1/test/test` will response in JSON format

`POST http://localhost/1/test/test?callback=cb` will response in JSONP + iFrame format

# Syntax

```javascript
new JSONTransport([options])
```

## Options

* __indentationString__: (`String`|`Boolean`: defaults to 3 spaces) the string used to format your json output or `false` to avoid the indentation
* __domain__ - (`String`: defaults to '.default.lan') the first level domain where your API will be consumed. ([???](#cors))

## Example

```javascript
new JSONTransport({
  indent: '  ',
  domain: '.example.com'
})
```

```javascript
new ApiServer({
  port: 80,
  timeout: 2000,
  indent: false, // passed to JSONTransport
  domain: '.example.com'   // passed to JSONTransport
})
```

The following methods are attached to the response:

# serveJSON

This method writes data back to the client and closes the response.

## Syntax

```javascript
response.serveJSON([data], [options])
```
## Arguments

* __data__ - (`Object`) the data to send back to the client
* __options__ - (`Object`)
  * __headers__ - (`Object`) a headers list that will eventually override the default ones
  * __httpStatusCode__ - (`Number`: defaults to 200)
  * __httpStatusMessage__ - (`String`: defaults to '')

## Example

```javascript
// decontextualized API method
function (request, response) {
  response.serveJSON({ foo: 'bar' })
})
```

```javascript
// decontextualized API method
function (request, response) {
  response.serveJSON(['foo','bar', ...], {
    httpStatusCode: 404,
    httpStatusMessage: 'maybe.. you\'re lost',
    headers: {
      'x-value': 'foo'
    }
  })
})
```

# streamJSON

The streamJSON is absolutely another __killer feature__. It allows you to stream JSON objects to the browser as soon as they are available to you, for example as soon as the [MongoDb CursorStream](http://mongodb.github.com/node-mongodb-native/api-generated/cursorstream.html) emits the `data` event. This means that we are keeping in memory only one object at time and consequently, saving memory.

_N.B. the browser still needs to wait the entire response to consume it_.

## Syntax

```javascript
response.streamJSON([data], [options])
```

## Arguments

* __data__ - (`Object`) the data to send back to the client
* __options__ - (`Object`)
  * __headers__ - (`Object`) a headers list that will eventually override the default ones
  * __httpStatusCode__ - (`Number`: defaults to 200)
  * __httpStatusMessage__ - (`String`: defaults to '')

To close the response you must call `streamJSON` once without arguments. JSONTransport will understand that this is the end of the streaming.

## Example

```javascript
// decontextualized API method
function (request, response) {
  var count = 3
  var interval = setInterval(function () {
    if (count === 0) {
      clearInterval(interval)
      response.streamJSON()
    } else {
      count--
      response.streamJSON({ foo: 'bar' })
    }
  }, 200)
})
```

yields

```javascript
[
   { "foo": "bar" },
   { "foo": "bar" },
   { "foo": "bar" }
]
```

# How to contribute

This repository follows (more or less) the [Felix's Node.js Style Guide](http://nodeguide.com/style.html), your contribution must be consistent with this style.

The test suite is written on top of [visionmedia/mocha](http://visionmedia.github.com/mocha/) and it took hours of hard work. Please use the tests to check if your contribution is breaking some part of the library and add new tests for each new feature.

    ⚡ npm test

and for your test coverage

    ⚡ make test-cov

## License

_This software is released under the MIT license cited below_.

    Copyright (c) 2010 Kilian Ciuffolo, me@nailik.org. All Rights Reserved.

    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation
    files (the 'Software'), to deal in the Software without
    restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following
    conditions:
    
    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
