CoffeeScript = require('coffee-script')
CoffeeScript.register()
expect = require('chai').expect

describe 'Task instance', ->
    it 'should have a name', ->
      test = 'test'
      expect(test).to.equal 'test'
