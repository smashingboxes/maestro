# Maestro

<img src="./roboto.png" width=270/>

A Slack-Powered music bot for Spotify, using [Sinatra](http://sinatrarb.com/) and [shpotify](https://github.com/hnarayanan/shpotify).

## Prerequisites

- Ruby
- OSX, with [homebrew](https://brew.sh/)

## Installation

```sh
brew install shpotify

git clone git@github.com:smashingboxes/maestro.git
cd maestro
bundle install
```

## Usage

```sh
ruby app.rb
```

This will start up Maestro on port 4567. To use it with Slack, you'll want to configure an external
URL, and set up a slash command. See the next section for details on how to do that.

Once that's done, you can interact with it via any command
[shpotify](https://github.com/hnarayanan/shpotify) supports. Here are the most common commands:

```
/maestro play <song name>
/maestro next
/maestro vol up
/maestro vol down
/maestro status
```

## Configuring Slack

### Obtaining an external URL

There are many ways to get an external URL or static IP. The easiest is to use [ngrok]():

```sh
brew cask install ngrok
ngrok http 4567
```

In the output, ngrok will provide you with an external url such as `http://71ca42f4.ngrok.io`,
you'll need that for the next section.

**NOTE: If ngrok gets restarted (during a computer restart, for example), a new URL will be
generated. You'll need to update your slash command with the new one.**

### Creating a slash command

To create a slash command in Slack, go [here](https://api.slack.com/outgoing-webhooks) and fill in
the following settings:

- Command: "/maestro"
- URL: Your external URL (from previous section)
- Method: POST
- Customize Name: Maestro
- Customize Icon: Any icon you'd like. Feel free to use [ours](./maestro.png)
- Autocomplete help text:
  - Check "Show this command in the autocomplete list"
  - Description: https://github.com/hnarayanan/shpotify
  - Usage hint: [shpotify command]

