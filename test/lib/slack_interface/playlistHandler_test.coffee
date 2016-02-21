expect = require('chai').expect
sinon = require('sinon')
PlaylistHandler = require('../../../lib/slack_interface/playlistHandler')
{ SpotifyHandler } = require('../../mochaHelper')

describe 'PlaylistHandler', ->
  before () ->
    SpotifyHandler.playlists = {
      '123': 'playlist 1',
      '4567': 'MusicWay'
    }
    @handler = new PlaylistHandler(SpotifyHandler)
    @add_playlist = sinon.stub(SpotifyHandler, 'add_playlist')
    @remove_playlist = sinon.stub(SpotifyHandler, 'remove_playlist')
    @rename_playlist = sinon.stub(SpotifyHandler, 'rename_playlist')
    @set_playlist = sinon.stub(SpotifyHandler, 'set_playlist')

  describe '#handleAddList', ->
    it 'responds', ->
      expect(@handler.handleAddList('name', 'uri')).to.eq 'Playlist Added'

    it 'tells the spotify handler to add the playlist', ->
      @handler.handleAddList('name', 'uri')
      [name, uri] = @add_playlist.firstCall.args
      expect(name).to.eq 'name'
      expect(uri).to.eq 'uri'

  describe '#handleRemoveList', ->
    it 'responds', ->
      expect(@handler.handleRemoveList('name')).to.eq 'Playlist Removed'

    it 'tells the spotify handler to remove the playlist', ->
      @handler.handleRemoveList('name')
      [name ] = @remove_playlist.firstCall.args
      expect(name).to.eq 'name'

  describe '#handleRenameList', ->
    it 'responds', ->
      expect(@handler.handleRenameList('old name', 'new name')).to.eq 'Playlist Renamed to new name'

    it 'tells the spotify handler to remove the playlist', ->
      @handler.handleRenameList('old name', 'new name')
      [ old_name, new_name ] = @rename_playlist.firstCall.args
      expect(old_name).to.eq 'old name'
      expect(new_name).to.eq 'new name'

  describe '#handlePlayPlaylist', ->
    it 'responds', ->
      expect(@handler.handlePlayPlaylist('name')).to.eq 'Playing name'

    it 'tells the spotify handler to remove the playlist', ->
      @handler.handlePlayPlaylist('name')
      [ name ] = @set_playlist.firstCall.args
      expect(name).to.eq 'name'

  describe '#handlePlayPlaylist', ->
    it 'responds', ->
      expect(@handler.handleList()).to.eq """
Currently available playlists:
*123* (playlist 1)
*4567* (MusicWay)
"""
  after ->
    @add_playlist.restore()
    @remove_playlist.restore()
    @rename_playlist.restore()
    @set_playlist.restore()

  afterEach ->
    @add_playlist.reset()
    @remove_playlist.reset()
    @rename_playlist.reset()
    @set_playlist.reset()
