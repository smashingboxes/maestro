# apiserver-router [![build status](https://secure.travis-ci.org/kilianc/node-apiserver-router.png?branch=master)](http://travis-ci.org/kilianc/node-apiserver-router)

A fast API router with integrated caching system bundled with [ApiServer](https://github.com/kilianc/node-apiserver)

## Installation

    ⚡ npm install apiserver-router

```js
var Router = require('apiserver-router')
```

## Quick Look

```js

// here just for example purposes,
// you don't need to call update directly, ApiServer will do it for you
router.update({
  '1': {
    'fooModule': {
      foo: {
        get:  function (request, response) {
          // GET http://localhost/foo/1/true    => request.querystring === { id: '1', verbose: 'true' }
          // GET http://localhost/foo_verbose/1 => request.querystring === { id: '1', verbose: true }
        },
        post: function (request, response) {
          // GET http://localhost/foo/1/true    => request.querystring === { id: '1', verbose: 'true' }
          // GET http://localhost/foo_verbose/1 => request.querystring === { id: '1', verbose: true }
        },
      },
      bar: function (request, response) {
        // * http://localhost/1/foo_module/bar
        // * http://localhost/bar
      }
    }
  }
})

// custom routing
router.addRoutes([
  ['/foo', '1/fooModule#foo'],
  ['/foo/:id/:verbose', '1/fooModule#foo'],
  ['/foo_verbose/:id', '1/fooModule#foo', { 'verbose': true }],
  ['/bar', '1/fooModule#bar', {}, true] // will keep default routing too
])

// you can also keep your routes on a separate .js(on) file
router.addRoutes(require('./config/routes'))
```

For full and detailed examples look at the [examples folder](https://github.com/kilianc/node-apiserver/tree/master/examples)

## Class Method: constructor

### Syntax:

```js
new Router([options])
```

### Available Options:

* __defaultRoute__ - (`String`: defaults to "/:version/:module/:method") the pattern for the default route

### Example:

```js
var router = new Router({
  // will disable the API versioning
  defaultRoute: '/:module/:method'
})

// will shift default routes to /api
router.defaultRoute = '/api/:version/:module/:method'
```

## Class Method: addRoute

Adds a custom route to the router.

The route can be both a `String` or a [`XRegExp`](https://github.com/slevithan/XRegExp). If you pass a `String`, it will be compiled as XRegExp and all matches of `:paramName` will create a new parameter in the `request.querystring` object.

The router uses XRegExp because of its named group feature and the full RegExp support. You can play around by yourself reading the official documentation.

A custom route will disable by default the standard route associated/cached with the __endpoint__. You can keep the standard one passing `true` as `keepDefault` parameter.

`defaultParameters` act as fill for missing parameters, but explicit querystring will overwrite both `default` and `routes parameter`.

### Syntax:

```js
Router.prototype.addRoute(route, methodDescription, [defaultParameters], [keepDefault])
```

### Arguments:

* __route__ - (`String|XRegExp`) the custom route to match, if string will be compiled to XRegExp
* __methodDescription__ - (`String`) a string in the following form "apiVersion/moduleName#methodName"
* __defaultParameters__ - (`Object`) an hash table containing default querystring paramenters
* __keepDefault__ - (`Boolean`: defaults to false) if true the default route will not be disabled

### Example

```js
router.addRoute('/users/:id', '1/usersModule#getUser')
router.addRoute('/users/verbose/:id', '1/usersModule#getUser', { verbose: true })
router.addRoute('/users/:limit/:page', '1/usersModule#list', { limit: 20, page: 1 })
router.addRoute(XRegExp('/users/status/(?<message>[\\w]+)'), '1/usersModule#saveStatus', null, true)
```
yelds

    /users/345                                => { id: '345' }
    /users/verbose/345                        => { id: '345', verbose: true }
    /users/verbose/345?id=201&verbose=false   => { id: '201', verbose: 'false' }
    /users/verbose/345?id=201&verbose=        => { id: '201', verbose: undefined }
    /users/status/coding%20likeaboss?id=34    => { id: '34', message: 'coding likeaboss' }
    /users/10/2                               => { limit: '10', page: '2' }


## Class Method: addRoutes

Call `addRoute` n times applying the arguments array

### Syntax:

```js
Router.prototype.addRoutes(routes)
```

### Arguments:

* __routes__ - (`Array`) an `Array` of `Array` with `addRoute` parameters

### Examples

```js
router.addRoutes([
  ['/users/:id', '1/usersModule#getUser'],
  ['/users/verbose/:id', '1/usersModule#getUser', { verbose: true }],
  ['/users/:limit/:page', '1/usersModule#list', { limit: 20, page: 1 }],
  [XRegExp('/users/status/(?<message>[\\w]+)'), '1/usersModule#saveStatus', null, true]
])
```

## Class Method: get

This method returns a list of functions that will be executed with [fnchain](https://github.com/kilianc/node-fnchain). The list will contain all the middleware active for the API endpoint reached by `pathname` and as last ring of the chain the API method to execute.

### Syntax:

```js
Router.prototype.get(request)
```

### Arguments:

* __request__ - (`ServerRequest`) the request object already extended by the [ApiServer](https://github.com/kilianc/node-apiserver)

### Example:

```js
var chanin = router.get(request)
```

## Class Method: update

Builds and caches the routes. You must call it every time a middleware or a module changes.

### Syntax:

```js
Router.prototype.update(modules[, middlewareList])
```

### Arguments:

* __modules__ - (`Object`) an hashtable of [API modules](https://github.com/kilianc/node-apiserver/tree/master#modules)
* __middlewareList__ - (`Array`) a list of [middleware](https://github.com/kilianc/node-apiserver/tree/master#middleware)


# How to contribute

This repository follows (more or less) the [Felix's Node.js Style Guide](http://nodeguide.com/style.html), your contribution must be consistent with this style.

The test suite is written on top of [visionmedia/mocha](http://visionmedia.github.com/mocha/) and it took hours of hard work. Please use the tests to check if your contribution breaks some part of the library and add new tests for each new feature.

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
