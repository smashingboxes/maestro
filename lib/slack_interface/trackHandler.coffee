BaseHandler = require('./baseHandler')

class TrackHandler extends BaseHandler
  handlePause: () ->
    @spotify.pause()

  handleStop: () ->
    @spotify.stop()

  handleSkip: (requestor) ->
    message = @spotify.skip(requestor)
    message if typeof(message) == 'string'

module.exports = TrackHandler
