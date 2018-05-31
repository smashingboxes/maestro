var should = require('should'),
    FnChain = require('../')

var once;

function delay() {
  var fn = this
  var args = arguments
  setTimeout(function () {
    fn.apply(null, args);
  }, 20);
}

describe('FnChain', function () {
  beforeEach(function () {
    once = false;
  })
  it('should pass the arguments through the functions chain', function (done) {
    new FnChain([
      function (p1, p2, next) {
        p1.should.be.equal('foo')
        p2.should.be.equal('bar')
        next()
      },
      function (p1, p2, next) {
        p1.should.be.equal('foo')
        p2.should.be.equal('bar')
        delay.call(next)
      },
      function (p1, p2, next) {
        p1.should.be.equal('foo')
        p2.should.be.equal('bar')
        delay.call(next)
      }
    ], function (err, p1, p2) {
      once.should.be.false
      once = true
      p1.should.be.equal('foo')
      p2.should.be.equal('bar')
      done(err)
    }).call('foo', 'bar')
  })
  it('should stop if requested', function (done) {
    new FnChain([
      function (p1, p2, next) {
        p1.step = 1
        delay.call(next)
      },
      function (p1, p2, next) {
        p1.step = 2
        delay.call(next, null, true)
      },
      function (p1, p2, next) {
        delay.call(next, new Error('3'))
      }
    ], function (err, p1, p2) {
      once.should.be.false
      once = true
      p1.step.should.be.equal(2)
      done(err)
    }).call({}, {})
  })
  it('should stop on error', function (done) {
    new FnChain([
      function (next) {
        delay.call(next)
      },
      function (next) {
        delay.call(next, new Error('2'))
      },
      function (next) {
        delay.call(next, new Error('3'))
      }
    ], function (err) {
      once.should.be.false
      once = true
      should.exist(err)
      err.message.should.be.equal('2')
      done()
    }).call()
  })
  it('should accept new task on the way', function (done) {
    var chain = new FnChain([
      function (next) {
        chain.addTask(function (next) {
          next(new Error('4'))
        })
        delay.call(next)
      },
      function (next) {
        chain.addTask(function (next) {
          delay.call(next, new Error('5'))
        })
        delay.call(next)
      },
      function (next) {
        delay.call(next)
      }
    ], function (err) {
      once.should.be.false
      once = true
      should.exist(err)
      err.message.should.be.equal('4')
      done()
    })
    chain.call()
  })
})