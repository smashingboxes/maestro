# Maestro

<img src="./roboto.png" width=270/>

A Slack-Powered music bot for Spotify, using [Sinatra](http://sinatrarb.com/) and [shpotify](https://github.com/hnarayanan/shpotify).

## Getting Started

The first thing you'll need to run Maestro is a computer to run it from. It'll need to be running
**OSX, with [homebrew](https://brew.sh/) installed**. It'll also need **Ruby**, which comes
pre-installed with OSX, so you should be good there. Lastly, but most importantly, this computer
is the one that will be playing the music, so it'll either need
**good speakers, or a headphone jack** to plug a sound system into.

Once you've got a computer to run it on, you can install Maestro by running the following commands
in a terminal:

```sh
brew install shpotify

git clone https://github.com/smashingboxes/maestro.git
cd maestro
bundle install
```

### Connecting to Spotify's api

shpotify needs to connect to Spotify’s API in order to find music by
name. It is very likely you want this feature!

To get this to work, you first need to sign up (or into) Spotify’s
developer site and [create an *Application*][spotify-dev]. Once you’ve
done so, you can find its `Client ID` and `Client Secret` values and
enter them into your shpotify config file at `${HOME}/.shpotify.cfg`.

Be sure to quote your values and don’t add any extra spaces. When
done, it should look like the following (but with your own values):

```sh
CLIENT_ID="abc01de2fghijk345lmnop"
CLIENT_SECRET="qr6stu789vwxyz"
```

## Usage

```sh
ruby app.rb
```

This will start up Maestro on port 4567. To use it with Slack, you'll want to configure an external
URL (see "Obtaining an external URL" below), and set up a slash command (see "Creating a slash
command" below).

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
generated. You'll need to update your slash command (created in the next section) with the
new one.**

### Creating a slash command

To create a slash command in Slack, go to https://slack.com/apps/A0F82E8CA-slash-commands, click "Add Configuration", and fill in the following settings:

- Command: "/maestro"
- URL: Your external URL (from previous section), followed by `/maestro`. So, for example, if your ngrok url is `http://71ca42f4.ngrok.io`, you'd enter `http://71ca42f4.ngrok.io/maestro`
- Method: POST
- Customize Name: Maestro
- Customize Icon: Any icon you'd like. Feel free to use [ours](./maestro.png)
- Autocomplete help text:
  - Check "Show this command in the autocomplete list"
  - Description: https://github.com/hnarayanan/shpotify
  - Usage hint: [shpotify command]
