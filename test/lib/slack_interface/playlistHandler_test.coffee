expect = require('chai').expect
handler = require('../../mochaHelper')
sinon = require('sinon')
PlaylistHandler = require('../../../lib/slack_interface/playlistHandler')
mocha_helper = require('../../mochaHelper')

describe 'PlaylistHandler', ->
  describe '#handleAddList', ->
    before () ->
      sinon.stub(mocha_helper.SpotifyHandler, 'add_playlist')

    it 'responds', ->
      handler = new PlaylistHandler(mocha_helper.SpotifyHandler)
      expect(handler.handleAddList('name', 'uri')).to.eq "Playlist Added"
