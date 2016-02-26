[![Build Status](https://travis-ci.org/smashingboxes/maestro.svg?branch=master)](https://travis-ci.org/smashingboxes/maestro)
[![Code Climate](https://codeclimate.com/github/smashingboxes/maestro/badges/gpa.svg)](https://codeclimate.com/github/smashingboxes/maestro)

# Maestro
Slack-Powered Spotify music bot.

## Install

1. Create a Spotify Premium Account.
1. Download a [Spotify App Developers Key](https://devaccount.spotify.com/my-account/keys/).
1. [Download the latest release](https://github.com/smashingboxes/maestro/releases/latest).
1. Put your `spotify_appkey.key` file in Maestro's root directory.
1. Create a [Slack Outgoing Webhook](https://api.slack.com/outgoing-webhooks).
1. Copy the token from the webhook into the `config.json` file.
1. Put your Spotify login infor into the `config.json` file.
1. `npm start`.

## Running Test

:see_no_evil: **You Must Use Node 0.10.x** :see_no_evil:

1. `git clone https://github.com/smashingboxes/maestro.git`.
1. `cd maestro`
1. `npm install`
1. `npm test`

## HOWTO
**Commands**
> `play [Spotify URI]` - Starts/resumes playback  
> `play [Spotify URI]` - Immediately switches to the linked track.  
> `pause` - Pauses playback at the current time.  
> `stop` - Stops playback and resets to the beginning of the current track.  
> `skip` - Skips (or shuffles) to the next track in the playlist.  
> `shuffle` - Toggles shuffle on or off.  
> `vol [up|down]` Turns the volume either up/down one notch.  
> `vol [0..10]` Adjust volume directory to a step between `0` and `10`.  
> `mute` - Same as `vol 0`.  
> `unmute` - Same as `vol 0`.  
> `status` - Shows the currently playing song, playlist and whether you're shuffling or not.  
> `voteban` - Cast a vote to have the current track banned  
> `banned` - See tracks that are currently banned  
> `help` - Shows a list of commands with a short explanation.  

**Queue**
> `queue [Spotify URI]` - Add a song to the queue  
> `queue` - See the tracks currently in the queue  

**Playlists**
> `list add <name> <Spotify URI>` - Adds a list that can later be accessed under <name>.  
> `list remove <name>` - Removes the specified list.  
> `list rename <old name> <new name>` - Renames the specified list.  
> `list <name>` - Selects the specified list and starts playback.  

([inspired by Crispify](https://github.com/crispymtn/crispyfi))
