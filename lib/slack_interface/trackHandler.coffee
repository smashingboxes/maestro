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

  handleStatus: () ->
    song = @spotify.state.track.name
    artist = @spotify.state.track.artists
    playlist = @spotify.state.playlist.name

    playlistOrderPhrase = if @spotify.state.shuffle
      " and it is being shuffled"
    else
      ""
    if @spotify.is_paused()
      return """
Playback is currently *paused* on a song titled *#{song}* from *#{artist}*.
Your currently selected playlist is named *#{playlist}*#{playlistOrderPhrase}.
Resume playback with `play`.
"""
    else if !@spotify.is_playing()
      return "Playback is currently *stopped*. You can `play` or choose a `list`."
    else
      return """
You are currently letting your ears feast on the beautiful tunes titled *#{song}* from *#{artist}*.
Your currently selected playlist is named *#{playlist}*#{playlistOrderPhrase}.
"""

  handleQueue: (uri) ->
    if uri != undefined
      @spotify.pushQueue(uri)
      'OK'
    else
      queued_tracks = @spotify.showQueue()
      response = ":musical_note: Queued Tracks :musical_note:\n"
      queued_tracks.forEach( (track, index) ->
        response += "#{index + 1}. #{track.name}"
        response += "*#{track.artists[0].name}*"
        response += "[#{track.album.name}]\n"
      )
      response
module.exports = TrackHandler
