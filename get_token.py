#!/usr/bin/env python3

import os

import spotipy
import spotipy.util as util

import userinfo

scope = 'playlist-modify-private'
username = userinfo.USER
playlist_id = userinfo.PLAYLIST
CLIENT_ID = userinfo.CLIENT_ID
CLIENT_SECRET = userinfo.CLIENT_SECRET

token = util.prompt_for_user_token(username,scope,client_id=CLIENT_ID,client_secret=CLIENT_SECRET,redirect_uri='https://localhost:4567/callback')
user_provided = ('.cache-'+username)
my_file = os.path.isfile(user_provided)
if my_file is True:
    print('Token has been cached, proceed to using Maestro')
else:
    print('Token could not be saved')