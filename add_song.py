#!/usr/bin/env python3

import pprint
import sys
import os
import subprocess
import spotipy
import spotipy.util as util

user_info_file = os.path.isfile('userinfo.py')
if user_info_file is True:
    import userinfo
else:
    print('userinfo file is not present, please run pre_setup_oauth.sh')

user_cache_file = os.path.isfile('.cache-drummerweed')

if user_cache_file is True:
    scope = 'playlist-modify-private'
    username = userinfo.USER
    playlist_id = userinfo.PLAYLIST
    CLIENT_ID = userinfo.CLIENT_ID
    CLIENT_SECRET = userinfo.CLIENT_SECRET
    PASSED_TRACK = sys.argv[1]

    track_ids = [PASSED_TRACK]
    token = util.prompt_for_user_token(username,scope,client_id=CLIENT_ID,client_secret=CLIENT_SECRET,redirect_uri='https://localhost:4567/callback')
    sp = spotipy.Spotify(auth=token)
    sp.trace = False
    playlists = sp.user_playlist_add_tracks(username, playlist_id, track_ids)
    #pprint.pprint(playlists)
    print("Song ", PASSED_TRACK, "\nhas been added to your Maestro playlist")
else:
    print("Token is not cached.\nPlease run the get_token.py file to cache your token.")