#!/usr/bin/env python3

import pprint
import sys
import os
import subprocess
import spotipy
import spotipy.util as util

my_file = os.path.isfile('.cache-drummerweed')

if my_file is True:
    scope = 'playlist-modify-private'

    if len(sys.argv) > 2:
        
        username = 'drummerweed'
        CLIENT_ID = sys.argv[1] 
        CLIENT_SECRET = sys.argv[2] 
        PASSED_TRACK = sys.argv[3] 
    else:
        print("Usage: %s CLIEND_ID, CLIENT_SECRET, PASSED_TRACK" % (sys.argv[0],))
        sys.exit()

    playlist_id = '5xdS7gI6C5KpKm4LHVKaUZ'
    track_ids = [PASSED_TRACK]
    token = util.prompt_for_user_token(username,scope,client_id=CLIENT_ID,client_secret=CLIENT_SECRET,redirect_uri='https://localhost:4567/callback')


    if token:
        sp = spotipy.Spotify(auth=token)
        sp.trace = False
        playlists = sp.user_playlist_add_tracks(username, playlist_id, track_ids)
        pprint.pprint(playlists)
    else:
        print("Can't get token for", username)
else:
    print("Token is not cached.\nPlease run the Token.py file to cache your token.")