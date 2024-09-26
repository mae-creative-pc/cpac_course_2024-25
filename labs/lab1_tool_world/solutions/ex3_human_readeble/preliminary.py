# %% Get Client_ID and Client Secret
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials

# 1) Go to your Dashboard: https://developer.spotify.com/dashboard
# 2) Create a new app: you can insert assign any value to each form fields
# 3) Click on the name of the app you have just created (My App)
# 4) Click on the Settings button
# 5) get your Client_ID and Client Secret

if 'client_id' not in locals(): # if you have not inserted the client_id 
    client_id=input("Insert your Client ID: ")
if 'client_secret' not in locals(): # if you have not inserted the client_secret 
    client_secret=input("Insert your Client secret: ")

sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id,
                                                           client_secret))

# %% Song search
results = sp.search(q='stand by me', limit=20)
for idx, track in enumerate(results['tracks']['items']):
    print(idx, track['artists'][0]['name'])
# %%
res_1 = results['tracks']['items'][5]
res_2 = results['tracks']['items'][11]

songs_title = [res_1['name'], res_2['name']] 
songs_artist = [res_1['artists'][0]['name'], res_2['artists'][0]['name']] 
songs_id = [res_1['id'], res_2['id']]
print(songs_id)

# %% Audio feature APIs
modes=["minor", "major"]
key_tonal=["C","C#", "D","D#","E","F","F#","G","G#","A","A#","B"]

audio_features=sp.audio_features(tracks=songs_id)

for i in range(0,2):

    print(songs_title[i], songs_artist[i])
    print("Duration: %.3f seconds"%(audio_features[i]["duration_ms"]/1000))
    print("BPM: %d"%audio_features[i]["tempo"])
    print("Key: %s-%s"%(key_tonal[audio_features[i]["key"]], 
                    modes[audio_features[i]["mode"]]))

    for feature in ["danceability", "energy", "speechiness", "acousticness","liveness","instrumentalness","valence"]:
        print("The %s of the song is %1.f %%"%(feature, 100*audio_features[i][feature]))
