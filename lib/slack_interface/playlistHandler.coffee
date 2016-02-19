class PlaylistHandler
  constructor: (spotify) ->
    @spotify = spotify

  handleAddList: (name, uri) ->
    @spotify.add_playlist(name, uri)
    "Playlist Added"

  handleRemoveList: (name) ->
    @spotify.remove_playlist(name)
    "Playlist Removed"

  handleRenameList: (old_name, new_name) ->
    @spotify.rename_playlist(old_name, new_name)
    "Playlist Renamed to #{new_name}"

  handlePlayPlaylist: (name) ->
    @spotify.set_playlist(name)
    "Playing #{name}"

  handleList: () ->
    res = 'Currently available playlists:'
    for key of @spotify.playlists
      res += "\n*#{key}* (#{@spotify.playlists[key]})"
    res

module.exports = PlaylistHandler
