PlaylistHandler = require('./playlistHandler')
TrackHandler = require('./trackHandler')

class SlackInterfaceRequestHandler
  constructor: (auth, spotify, volume) ->
    @auth = auth
    @spotify = spotify
    @volume = volume
    @playlistHandler = new PlaylistHandler(spotify)
    @trackHandler = new TrackHandler(spotify)

    @endpoints =
      handle:
        post: (request, response) =>
          request.resume()
          request.once "end", =>
            return if !@auth.validate(request, response)

            reply_data = { ok: true }

            return if @auth.user_name == 'slackbot'

            reply_data['text'] = switch @auth.command.toLowerCase()
              when 'pause'   then @trackHandler.handlePause()
              when 'stop'    then @trackHandler.handleStop()
              when 'skip'    then @trackHandler.handleSkip(@auth.user_name)
              when 'play'    then @trackHandler.handlePlay(@auth.args[0])
              when 'status'  then @trackHandler.handleStatus()
              when 'queue'   then @trackHandler.handleQueue(@auth.args[0])
              when 'shuffle' then @trackHandler.handleShuffle()
              when 'mute'    then @handleMute()
              when 'vol'     then @handleVol()
              when 'help'    then @handleHelp()
              when 'voteban' then @handleVoteBan()
              when 'banned'  then @handleBanned()
              when 'list'
                switch @auth.args[0]
                  when 'add' then @playlistHandler.handleAddList(@auth.args[1], @auth.args[2])
                  when 'remove' then @playlistHandler.handleRemoveList(@auth.args[1])
                  when 'rename' then @playlistHandler.handleRenameList(@auth.args[1], @auth.args[2])
                  when undefined then @playlistHandler.handleList()
                  else
                    @playlistHandler.handlePlayPlaylist(@auth.args[0])
              else
                #Just ignore and carry on
            response.serveJSON reply_data
            return
          return

  handleMute: () ->
    @volume.set 0

  handleVol: () ->
    if @auth.args[0]?
      switch @auth.args[0]
        when "up" then @volume.up()
        when "down" then @volume.down()
        else @volume.set @auth.args[0]
    else
      "Current Volume: *#{@volume.current_step}*"

  handleHelp: () ->
    response ="""
You seem lost. Here is a list of commands that are available to you:
*Commands*
> `play [Spotify URI]` - Starts/resumes playback
> `play [Spotify URI]` - Immediately switches to the linked track.
> `pause` - Pauses playback at the current time.
> `stop` - Stops playback and resets to the beginning of the current track.
> `skip` - Skips (or shuffles) to the next track in the playlist.
> `shuffle` - Toggles shuffle on or off.
> `vol [up|down]` Turns the volume either up/down one notch.
> `vol [0..10]` Adjust volume directory to a step between `0` and `10`.
> `mute` - Same as `vol 0`.
> `unmute` - Same as `vol 0`.
> `status` - Shows the currently playing song, playlist and whether you're shuffling or not.
> `voteban` - Cast a vote to have the current track banned
> `banned` - See tracks that are currently banned
> `help` - Shows a list of commands with a short explanation.

*Queue*
> `queue [Spotify URI]` - Add a song to the queue
> `queue` - See the tracks currently in the queue

*Playlists*
> `list add <name> <Spotify URI>` - Adds a list that can later be accessed under <name>.
> `list remove <name>` - Removes the specified list.
> `list rename <old name> <new name>` - Renames the specified list.
> `list <name>` - Selects the specified list and starts playback.
"""

  handleVoteBan: () ->
    if status = @spotify.banCurrentSong(@auth.user)
      "#{@spotify.state.track.name} is #{status}"
      @spotify.skip() if status == 'banned'
    else
      "#{@spotify.state.track.name} has *already* been banned"

  handleBanned: () ->
    ":rotating_light: BANNED TRACKS :rotating_light: \n#{@spotify.bannedSongs().join("\n")}"

module.exports = (auth, spotify, volume) ->
  handler = new SlackInterfaceRequestHandler(auth, spotify, volume)
  return handler.endpoints
