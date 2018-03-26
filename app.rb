require "sinatra"
require "json"

# rubocop:disable Style/MutableConstant
HELP_TEXT = <<~HELP_TEXT
  `play` -- Resumes playback where Spotify last left off.
  `play <song name>` -- Finds a song by name and plays it.
  `play album <album name>` -- Finds an album by name and plays it.
  `play artist <artist name>` -- Finds an artist by name and plays it.
  `play list <playlist name>` -- Finds a playlist by name and plays it.
  `play uri <uri>` -- Play songs from specific uri.

  `next` -- Skips to the next song in a playlist.
  `prev` -- Returns to the previous song in a playlist.
  `replay` -- Replays the current track from the begining.
  `pos <time>` -- Jumps to a time (in secs) in the current song.
  `pause` -- Pauses (or resumes) Spotify playback.
  `stop` -- Stops playback.
  `quit` -- Stops playback and quits Spotify.

  `vol up` -- Increases the volume by 10%.
  `vol down` -- Decreases the volume by 10%.
  `vol <amount>` -- Sets the volume to an amount between 0 and 100.
  `vol [show]` -- Shows the current Spotify volume.

  `status` -- Shows the current player status.

  `share` -- Displays the current song's Spotify URL and URI.
  `share url` -- Displays the current song's Spotify URL and copies it to the clipboard.
  `share uri` -- Displays the current song's Spotify URI and copies it to the clipboard.

  `toggle shuffle` -- Toggles shuffle playback mode.
  `toggle repeat` -- Toggles repeat playback mode.
HELP_TEXT

def spotify(args)
  return [HELP_TEXT, true] if args == "help"
  puts "# > spotify #{args}"
  output = `./spotify.sh #{args}`
  puts output
  [output, $?.success?]
end

post "/maestro" do
  output, success = spotify(params["text"])

  response_code = success ? 200 : 422
  body = { response_type: "in_channel", text: output }

  content_type :json

  [response_code, body.to_json]
end
