import numpy as np
TEACHER_CODE=False
def sort_songs(audio_features):
    """"Receive audio features and sort them according to your criterion"

    Args:
        audio_features (list of dictionaries): List of songs with audio features

    Returns:
        array of sorted id songs
    """

    sorted_ids = []
    # Random shuffle: replace it!
    if TEACHER_CODE:
        random_idxs=np.random.permutation(len(audio_features))
        for idx in random_idxs:
            sorted_ids.append(audio_features[idx]['id'])
    else:
        danceability = np.array([af["danceability"] for af in audio_features])
        idxs = np.argsort(danceability)
        N_third= int(len(audio_features)/3)
        low_danceability_idxs = idxs[0:N_third]
        mid_danceability_idxs = idxs[N_third:2*N_third]
        high_danceability_idxs = idxs[2*N_third:]
        sorted_idxs= np.concatenate([mid_danceability_idxs, 
                               high_danceability_idxs,
                               low_danceability_idxs[::-1]])
        for idx in sorted_idxs.flatten():
            sorted_ids.append(audio_features[int(idx)]['id'])
        
        # your code here

    return sorted_ids