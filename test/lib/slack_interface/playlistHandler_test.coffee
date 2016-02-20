expect = require('chai').expect
handler = require('../../mochaHelper')
sinon = require('sinon')
PlaylistHandler = require('../../../lib/slack_interface/playlistHandler')
mocha_helper = require('../../mochaHelper')

describe 'test', ->
  before () ->
    spotify = sinon.stub(mocha_helper.spotify, 'set_playlist')
    handler = new PlaylistHandler(sinon.stub(sinon.stub(), 'set_playlist'))

  it 'works', ->
    console.log handler
    expect(PlaylistHandler).to.eq "test"
