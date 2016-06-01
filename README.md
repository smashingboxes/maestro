# Maestro

[![Build Status](https://travis-ci.org/smashingboxes/maestro.svg?branch=master)](https://travis-ci.org/smashingboxes/maestro)
[![Code Climate](https://codeclimate.com/github/smashingboxes/maestro/badges/gpa.svg)](https://codeclimate.com/github/smashingboxes/maestro)
<img src='/roboto.png' width=350/>

Slack-Powered Spotify music bot.

## Install

:see_no_evil: **You Must Use Node 0.10.x** :see_no_evil:  
:see_no_evil: **Only Works on OSX** :see_no_evil:

### Configuring Spotify
1. Create a Spotify Premium Account.
1. `brew install libspotify` install libspotify
1. Download a [Spotify App Developers Key](https://devaccount.spotify.com/my-account/keys/).

### Configuring the Slack integration
1. Create a [Slack Outgoing Webhook](https://api.slack.com/outgoing-webhooks).
1. In URL(s) put `<address_to_your_bot>/handle` [we use ngrok for this](https://ngrok.com/)
1. In Trigger Word(s) put `play, pause, stop, skip, shuffle, vol, list, status, help, mute, unmute, banned, voteban, queue`

### Starting the Bot
1. [Download the latest release](https://github.com/smashingboxes/maestro/releases/latest).
1. Unzip and cd into the maestro directory
1. `cp config.example.json config.json`
1. `npm install`
1. Put your Spotify login username and password into the `config.json` file.
1. Put your `spotify_appkey.key` file in Maestro's root directory.
1. Copy the token from the webhook into the `config.json` file.
1. `npm start`.
1. Plug your **OSX** machine into some speakers.
1. Jam :headphones:

## Running Test

:see_no_evil: **You Must Use Node 0.10.x** :see_no_evil:

1. `git clone https://github.com/smashingboxes/maestro.git`.
1. `cd maestro`
1. Follow the install steps to create a Spotify token and configure the app.
1. `npm install`
1. `npm test`

## Commands
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
