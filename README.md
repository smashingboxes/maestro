# Maestro

[![Build Status](https://travis-ci.org/smashingboxes/maestro.svg?branch=master)](https://travis-ci.org/smashingboxes/maestro)
[![Code Climate](https://codeclimate.com/github/smashingboxes/maestro/badges/gpa.svg)](https://codeclimate.com/github/smashingboxes/maestro)
<img src='/roboto.png' width=270/>

A Slack-Powered music bot for Spotify.

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

>  `/maestro play` -- Resumes playback where Spotify last left off.
>  `/maestro play <song name>` -- Finds a song by name and plays it.
>  `/maestro play album <album name>` -- Finds an album by name and plays it.
>  `/maestro play artist <artist name>` -- Finds an artist by name and plays it.
>  `/maestro play list <playlist name>` -- Finds a playlist by name and plays it.
>  `/maestro play uri <uri>` -- Play songs from specific uri.

>  `/maestro next` -- Skips to the next song in a playlist.
>  `/maestro prev` -- Returns to the previous song in a playlist.
>  `/maestro replay` -- Replays the current track from the begining.
>  `/maestro pos <time>` -- Jumps to a time (in secs) in the current song.
>  `/maestro pause` -- Pauses (or resumes) Spotify playback.
>  `/maestro stop` -- Stops playback.
>  `/maestro quit` -- Stops playback and quits Spotify.
>  `/maestro restart` -- Quits and restarts Spotify.

>  `/maestro vol up` -- Increases the volume by 10%.
>  `/maestro vol down` -- Decreases the volume by 10%.
>  `/maestro vol <amount>` -- Sets the volume to an amount between 0 and 100.
>  `/maestro vol` -- Shows the current Spotify volume.
>  `/maestro status` -- Shows the current player status.

>  `/maestro share` -- Displays the current song's Spotify URL and URI.
>  `/maestro share url` -- Displays the current song's Spotify URL.
>  `/maestro share uri` -- Displays the current song's Spotify URI.

>  `/maestro toggle shuffle` -- Toggles shuffle playback mode.
>  `/maestro toggle repeat` -- Toggles repeat playback mode.

([inspired by Crispify](https://github.com/crispymtn/crispyfi))
