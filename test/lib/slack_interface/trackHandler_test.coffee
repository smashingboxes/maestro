expect = require('chai').expect
stub = require('sinon').stub
TrackHandler = require('../../../lib/slack_interface/trackHandler')
{ SpotifyHandler } = require('../../mochaHelper')

describe 'TrackHandler', ->
  before () ->
    @handler = new TrackHandler(SpotifyHandler)
    @pause = stub(SpotifyHandler, 'pause')

  describe '#handlePause', ->
    before () ->

    it 'will pause the track', () ->
      @handler.handlePause()
      expect(@pause.calledOnce).to.be.true

    it 'will respond back with nothing', () ->
      @handler.handlePause()
      expect(@handler.handlePause()).to.eq undefined

  after () ->
    @pause.restore()

  afterEach ->
    @pause.reset()
