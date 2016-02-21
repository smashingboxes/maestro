expect = require('chai').expect
stub = require('sinon').stub
TrackHandler = require('../../../lib/slack_interface/trackHandler')
Queue = require('../../../lib/queue')
{ SpotifyHandler } = require('../../mochaHelper')

describe 'TrackHandler', ->
  before ->
    @handler = new TrackHandler(SpotifyHandler)
    @pause = stub(SpotifyHandler, 'pause')
    @stop = stub(SpotifyHandler, 'stop')
    @play = stub(SpotifyHandler, 'play')

  describe '#handlePause', ->
    it 'will pause the track', ->
      @handler.handlePause()
      expect(@pause.calledOnce).to.be.true

    it 'will respond back with nothing', ->
      expect(@handler.handlePause()).to.eq undefined

  describe '#handleStop', ->
    it 'will stop the track', ->
      @handler.handleStop()
      expect(@stop.calledOnce).to.be.true

    it 'will respond back with nothing', () ->
      expect(@handler.handleStop()).to.eq undefined

  describe '#handleSkip', ->
    context 'when there is not a queued song playing', ->
      before ->
        @skip = stub(SpotifyHandler, 'skip')

      it 'will skip the track', () ->
        @handler.handleSkip()
        expect(@skip.calledOnce).to.be.true

      it 'will respond with nothing if there is no queue', () ->
        expect(@handler.handleSkip()).to.eq undefined

      afterEach ->
        @skip.reset()

      after ->
        @skip.restore()

    context 'when there is a queued song playing', ->
      beforeEach ->
        SpotifyHandler.queued_song_playing = true
        SpotifyHandler.voteskips = []

      context 'and there is not enought voteskips to skip', ->
        it 'will respond with voteskip request response', ->
          expect(@handler.handleSkip('brandon')).to.eq 'skip requested (1/3)'

        it 'will not call play', ->
          expect(@play.callCount).to.eq 0

      context 'when there are enought voteskips to skip', ->
        before ->
          @get_next_track = stub(SpotifyHandler, 'get_next_track', -> return 'spotify:track:7ueP5u2qkdZbIPN2YA6LR0')

        beforeEach ->
          @handler.handleSkip('one')
          @handler.handleSkip('two')

        it 'will play the next track', ->
          @handler.handleSkip('brandon')
          expect(@play.calledOnce).to.be.true

        it 'will response with a voteskip success response', ->
          expect(@handler.handleSkip('brandon')).to.eq 'skip vote passed (3/3) [one,two,brandon]'

        afterEach ->
          @get_next_track.reset()

        after ->
          @get_next_track.restore()

  describe '#play', ->
    context 'when no track uri is provided', ->
      it 'will start playing music', ->
        @handler.handlePlay()
        expect(@play.calledOnce).to.be.true

    context 'when a track uri is provided', ->
      it 'will start playing that track', ->
        @handler.handlePlay('track_uri')
        [uri] = @play.firstCall.args
        expect(uri).to.eq 'track_uri'

    context 'when there is a queue', ->
      before ->
        queue = new Queue
        queue.push 'next_queue_track_uri'
        SpotifyHandler.queue = queue

      it 'will ask you to use the queue', ->
        expect(@handler.handlePlay('uri')).to.eq 'Please use the queue.'

      after ->
        SpotifyHandler.queue = []

  afterEach ->
    @pause.reset()
    @stop.reset()
    @play.reset()

  after ->
    @pause.restore()
    @stop.restore()
    @play.restore()
