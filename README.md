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


([inspired by Crispify](https://github.com/crispymtn/crispyfi))
