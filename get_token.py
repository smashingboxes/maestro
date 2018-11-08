#!/usr/bin/env python3

import pprint
import sys
import os
import subprocess
import spotipy
import spotipy.util as util

scope = 'playlist-modify-private'
username = 'drummerweed'
playlist_id = '5xdS7gI6C5KpKm4LHVKaUZ'
CLIENT_ID = 'afac0221155d4a6b8ef3e3e2f4909635' 
CLIENT_SECRET = 'ccf370c58bbe4d22aaf0cb7ac39193a2'

token = util.prompt_for_user_token(username,scope,client_id=CLIENT_ID,client_secret=CLIENT_SECRET,redirect_uri='https://localhost:4567/callback')
my_file = os.path.isfile('.cache-drummerweed')
if my_file is True:
    print('Token has been cached, proceed to using Maestro')
else:
    print('Token could not be saved')