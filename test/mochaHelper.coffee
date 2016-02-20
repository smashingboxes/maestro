Spotify = require '../lib/spotify/mac/nodespotify'
Config = require '../config.json'
Spotify = require "../lib/spotify/mac/spotify"
sinon = require 'sinon'
path = require 'path'
store = require 'node-persist'

appkey_path = path.resolve __dirname + "../../", 'spotify_appkey.key'

SpotifyHandler = require("../lib/spotify_handler")({
  test: "Trash",
  storage: store,
  config: Config.spotify
  spotify: Spotify({ appkeyFile: appkey_path  }),
})

module.exports = {
  SpotifyHandler
}
