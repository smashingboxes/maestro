require "sinatra"
require "json"
require "./spotify.rb"

HELP_TEXT = <<~HELP_TEXT.freeze
  Usage:
  `/maestro play` -- Resumes playback where Spotify last left off.
  `/maestro play <song name>` -- Finds a song by name and plays it.
  `/maestro play album <album name>` -- Finds an album by name and plays it.
  `/maestro play artist <artist name>` -- Finds an artist by name and plays it.
  `/maestro play list <playlist name>` -- Finds a playlist by name and plays it.
  `/maestro play uri <uri>` -- Play songs from specific uri.

  `/maestro next` -- Skips to the next song in a playlist.
  `/maestro prev` -- Returns to the previous song in a playlist.
  `/maestro replay` -- Replays the current track from the begining.
  `/maestro pos <time>` -- Jumps to a time (in secs) in the current song.
  `/maestro pause` -- Pauses (or resumes) Spotify playback.
  `/maestro stop` -- Stops playback.
  `/maestro quit` -- Stops playback and quits Spotify.
  `/maestro restart` -- Quits and restarts Spotify.

  `/maestro vol up` -- Increases the volume by 10%.
  `/maestro vol down` -- Decreases the volume by 10%.
  `/maestro vol <amount>` -- Sets the volume to an amount between 0 and 100.
  `/maestro vol` -- Shows the current Spotify volume.

  `/maestro status` -- Shows the current player status.

  `/maestro share` -- Displays the current song's Spotify URL and URI.
  `/maestro share url` -- Displays the current song's Spotify URL.
  `/maestro share uri` -- Displays the current song's Spotify URI.

  `/maestro toggle shuffle` -- Toggles shuffle playback mode.
  `/maestro toggle repeat` -- Toggles repeat playback mode.
HELP_TEXT

# Find methods unique to Spotify class
VALID_COMMANDS = (Spotify.public_methods - Object.public_methods).freeze

def process_spotify_command(args)
  command, *params = *split_args(args)
  command = command.downcase.to_sym
  return [HELP_TEXT, true] if args == "help" || !VALID_COMMANDS.include?(command)
  Spotify.public_send(*format_params(command, params))
end

def format_params(command, params)
  [command, params.join(" ")].reject(&:empty?)
end

def split_args(args)
  args.split(" ")
end

post "/maestro" do
  output, success = process_spotify_command(params["text"])

  response_code = success ? 200 : 422
  body = { response_type: "in_channel", text: output }

  content_type :json

  [response_code, body.to_json]
end
