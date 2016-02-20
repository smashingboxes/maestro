module.exports = () ->
  Config = require '../../config.json'
  CronJob = require('cron').CronJob
  os = require 'os'
  path = require 'path'

  # Path to Spotify's AppKey
  root_dir = path.dirname require.main.filename
  appkey_path = path.resolve __dirname + "../../../", 'spotify_appkey.key'

  Spotify = require "../spotify/mac/spotify"

  store = require 'node-persist'

  AuthHandler = require('../auth_handler')(Config.auth)
  VolumeHandler = require('../volume_handler')()
  SpotifyHandler = require('../spotify_handler')({
    test: "Junk 2",
    spotify: Spotify { appkeyFile: appkey_path  }
    storage: store.initSync(),
    config: Config.spotify
  })

  nightlyReset = new CronJob
    cronTime: "00 30 19 * * 1-5"
    onTick: ->
      SpotifyHandler.stop()
      VolumeHandler.set(3)
    start: true

  return require('./request_handler')(AuthHandler, SpotifyHandler, VolumeHandler)
