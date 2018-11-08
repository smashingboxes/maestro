#!/usr/bin/env python3

import pprint
import sys
import os
import subprocess
import time

import spotipy
import spotipy.util as util

ff_user = ('USER = "' + sys.argv[1] +'"')
ff_client_id = ('CLIENT_ID = "' + sys.argv[2] +'"')
ff_client_secret = ('CLIENT_SECRET = "' + sys.argv[3] +'"')
ff_playlist_id = ('PLAYLIST = "' + sys.argv[4] +'"')

f = open("userinfo.py", "a")
f.write(ff_user)
f.write('\n')
f.write(ff_client_id)
f.write('\n')
f.write(ff_client_secret)
time.sleep(2)
f.write('\n')
f.write(ff_playlist_id)

print('userinfo file created')