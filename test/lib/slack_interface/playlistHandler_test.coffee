expect = require('chai').expect
sinon = require('sinon')
PlaylistHandler = require('../../../lib/slack_interface/playlistHandler')
{ SpotifyHandler } = require('../../mochaHelper')

describe 'PlaylistHandler', ->
  describe '#handleAddList', ->
    before () ->
      @handler = new PlaylistHandler(SpotifyHandler)
      @add_playlist = sinon.stub(SpotifyHandler, 'add_playlist')

    it 'responds', ->
      expect(@handler.handleAddList('name', 'uri')).to.eq 'Playlist Added'

    it 'tells the spotify handler to add the playlist', ->
      @handler.handleAddList('name', 'uri')
      [name, uri] = @add_playlist.firstCall.args
      expect(name).to.eq 'name'
      expect(uri).to.eq 'uri'

    after ->
      @add_playlist.restore()

    afterEach ->
      @add_playlist.restore()

  describe '#handleRemoveList', ->
    before ->
      @handler = new PlaylistHandler(SpotifyHandler)
      @remove_playlist = sinon.stub(SpotifyHandler, 'remove_playlist')

    it 'responds', ->
      expect(@handler.handleRemoveList('name')).to.eq 'Playlist Removed'

    it 'tells the spotify handler to remove the playlist', ->
      @handler.handleRemoveList('name')
      [name ] = @remove_playlist.firstCall.args
      expect(name).to.eq 'name'

    after ->
      @remove_playlist.restore()

    afterEach ->
      @remove_playlist.restore()

  describe '#handleRenameList', ->
    before ->
      @handler = new PlaylistHandler(SpotifyHandler)
      @rename_playlist = sinon.stub(SpotifyHandler, 'rename_playlist')

    it 'responds', ->
      expect(@handler.handleRenameList('old name', 'new name')).to.eq 'Playlist Renamed to new name'

    it 'tells the spotify handler to remove the playlist', ->
      @handler.handleRenameList('old name', 'new name')
      [ old_name, new_name ] = @rename_playlist.firstCall.args
      expect(old_name).to.eq 'old name'
      expect(new_name).to.eq 'new name'

    after ->
      @rename_playlist.restore()

    afterEach ->
      @rename_playlist.restore()

  describe '#handlePlayPlaylist', ->
    before ->
      @handler = new PlaylistHandler(SpotifyHandler)
      @set_playlist = sinon.stub(SpotifyHandler, 'set_playlist')

    it 'responds', ->
      expect(@handler.handlePlayPlaylist('name')).to.eq 'Playing name'

    it 'tells the spotify handler to remove the playlist', ->
      @handler.handlePlayPlaylist('name')
      [ name ] = @set_playlist.firstCall.args
      expect(name).to.eq 'name'

    after ->
      @set_playlist.restore()

    afterEach ->
      @set_playlist.restore()

  describe '#handlePlayPlaylist', ->
    before ->
      @handler = new PlaylistHandler(SpotifyHandler)
      SpotifyHandler.playlists = {
        '123': 'playlist 1',
        '4567': 'MusicWay'
      }

    it 'responds', ->
      expect(@handler.handleList()).to.eq """
Currently available playlists:
*123* (playlist 1)
*4567* (MusicWay)
"""
