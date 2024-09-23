# %% Import what we need

import os
import json
import numpy as np
os.chdir(os.path.abspath(os.path.dirname(__file__)))
import your_code
import spotipy
from spotipy.oauth2 import SpotifyOAuth

if 'client_id' not in locals(): # if you have not inserted the client_id 
    client_id=input("Insert your Client ID: ")
if 'client_secret' not in locals(): # if you have not inserted the client_secret 
    client_secret=input("Insert your Client secret: ")
if 'redirect_uri' not in locals(): # if you have not inserted the redirect_uri 
    redirect_uri=input("Insert your Redirect URI: ")
# Go to https://open.spotify.com/ , top right corner, press "Account"
# look at your username
if 'username' not in locals(): # if you have not inserted the redirect_uri 
    username=input("Insert your Username: ")

scope = 'playlist-modify-public, playlist-modify-private'
sp = spotipy.Spotify(auth_manager=SpotifyOAuth(client_id=client_id,
                                               client_secret=client_secret,
                                               redirect_uri=redirect_uri,
                                               scope=scope))

# %% Get the list of songs
assert os.path.exists("list_of_songs.json"), "Please put here a list of songs"
with open("list_of_songs.json",'r') as fp:
    ids=json.load(fp)["ids"]

# %% Get the audio features
audio_features=sp.audio_features(tracks=ids)


# %% Now let's create some way to organize them!
shuffled_songs=your_code.sort_songs(audio_features)


# %% Create the playlist
playlist_name = 'CPAC party 2023'
playlist_description = 'Created during CPAC'
playlist = sp.user_playlist_create(username, playlist_name, public=True, collaborative=False, description=playlist_description)

# %% fill the playlist the playlist
results = sp.playlist_add_items(playlist['id'], shuffled_songs, position=None)