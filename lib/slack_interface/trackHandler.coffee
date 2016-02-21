BaseHandler = require('./baseHandler')

class TrackHandler extends BaseHandler
  handlePause: () ->
    @spotify.pause()

  handleStop: () ->
    @spotify.stop()

  handleSkip: (requestor) ->
    message = @spotify.skip(requestor)
    message if typeof(message) == 'string'

  handlePlay: (uri) ->
    if uri? && @spotify.queue.length() > 0
      "Please use the queue."
    else if uri?
      @spotify.play uri
    else
      @spotify.play()

module.exports = TrackHandler
