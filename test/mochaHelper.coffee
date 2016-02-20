Spotify = require('../lib/spotify/mac/nodespotify')

path = require('path')
appkey_path = path.resolve __dirname + "../../", 'spotify_appkey.key'

spotify = Spotify { appkeyFile: appkey_path  }

module.exports = {
  spotify
}
