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
          track = 'spotify:track:7ueP5u2qkdZbIPN2YA6LR0'
          @get_next_track = stub(SpotifyHandler, 'get_next_track', -> track)

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

  describe '#handleStatus', ->
    beforeEach ->
      SpotifyHandler.state =
        track:
          name: 'great song'
          artist: 'brandon mathis'
        playlist:
          name: 'great playlist'

    context 'when playback is stopped', ->
      before ->
        @is_playing = stub(SpotifyHandler, 'is_playing', () -> false)

      it 'will tell you if playback is stopped', ->
        expect(@handler.handleStatus()).to.match /stopped/

      afterEach ->
        @is_playing.reset()

      after ->
        @is_playing.restore()

    context 'when playback is paused', ->
      before ->
        @is_paused = stub(SpotifyHandler, 'is_paused', () -> true)
        @initial_state = SpotifyHandler.state

      it 'will tell you that playback is paused', ->
        expect(@handler.handleStatus()).to.match /\*paused\* on a song titled/

      it 'will tell you what track it is paused on', ->
        expect(@handler.handleStatus()).to.match /great song/

      afterEach ->
        @is_paused.reset()

      after ->
        @is_paused.restore()

    context 'when playing', ->
      before ->
        @is_playing = stub(SpotifyHandler, 'is_playing', () -> true)

      it 'will tell you what track is currently active', ->
        expect(@handler.handleStatus()).to.match /beautiful tunes titled \*great song\*/

      afterEach ->
        @is_playing.reset()

      after ->
        @is_playing.restore()

      context 'when playback is shuffled', ->
        beforeEach ->
          SpotifyHandler.state =
            shuffle: true
            track:
              name: 'great song'
              artist: 'brandon mathis'
            playlist:
              name: 'great playlist'

        it 'will tell you that playback is being shuffled', () ->
          expect(@handler.handleStatus()).to.match /shuffled/

      context 'when playback is not being shuffled', ->
        beforeEach ->
          SpotifyHandler.state =
            shuffle: false
            track:
              name: 'great song'
              artist: 'brandon mathis'
            playlist:
              name: 'great playlist'

        it 'will not say that playback is being shuffled', ->
          expect(@handler.handleStatus()).to.not.match /shuffled/

    afterEach ->
      SpotifyHandler.state = @initial_state

  afterEach ->
    @pause.reset()
    @stop.reset()
    @play.reset()

  after ->
    @pause.restore()
    @stop.restore()
    @play.restore()
