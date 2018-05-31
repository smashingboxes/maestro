# FnChain [![build status](https://secure.travis-ci.org/kilianc/node-fnchain.png?branch=master)](http://travis-ci.org/kilianc/node-fnchain)

Serial control flow with explicit progression

## Installation

    $ npm install fnchain

## Usage

```javascript
new FnChain(Array, Function)
```

- Array of functions each one in the form `function (p1, p2, pN, ..., next)`, where next is the step callback
- Final callback in the canonical form `function (err, p1, p2, pN, ...)`

Each function in the chain should call the step callback in order to
advance the execution. You can also stop the chain passing `true` as last parameter
to the above mentioned step callback _(look at the examples)_

## Methods

```javascript
FnChain.call(p1, p2, pN, ...)
```
Fire the chain execution calling each function with the provided arguments
Nothing related with `Function.call`

```javascript
FnChain.addTask(Function)
```
Push a new task to the end of the chain (available even with the chain in progress)

## Examples

### Stop on error

```javascript
var FnChain = require('chain');

new FnChain([
  function (p1, p2, next) {
    next()
  },
  function (p1, p2, next) {
    next(new Error('TerribleError'))
  },
  function (p1, p2, next) {
    // never fired
    next()
  }
], function (err, p1, p2) {
  err.message === 'TerribleError'
}).call('foo', 'bar')
```

### Explicit stop

```javascript
new FnChain([
  function (p1, p2, next) {
    next()
  },
  function (p1, p2, next) {
    next(null, true) // stop the chain
  },
  function (p1, p2, next) {
    // never fired
    next()
  }
], function (err, p1, p2) {
  err === undefined
}).call('foo', 'bar')

```

### In progress addTask

```javascript
var chain = new FnChain([
  function (p1, p2, next) {
    next()
  },
  function (p1, p2, next) {
    chain.addTask(function (p1, p2, next) {
      // executed at the end
      next()
    })
    next()
  },
  function (p1, p2, next) {
    // never fired
    next()
  }
], function (err, p1, p2) {
  
})
chain.call('foo', 'bar')

```

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
