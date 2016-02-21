Config = require '../config.json'
if process.env.NODE_ENV == 'travis'
  Spotify = require "../lib/spotify/travis/spotify"
else
  Spotify = require "../lib/spotify/mac/spotify"

sinon = require 'sinon'
path = require 'path'
store = require 'node-persist'

appkey_path = path.resolve __dirname + "../../", 'spotify_appkey.key'

store.initSync()

SpotifyHandler = require("../lib/spotify_handler")({
  storage: store,
  config: Config.spotify
  spotify: Spotify({ appkeyFile: appkey_path  }),
})

module.exports = {
  SpotifyHandler
}
