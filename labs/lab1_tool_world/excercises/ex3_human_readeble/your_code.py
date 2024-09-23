import numpy as np
TEACHER_CODE=True
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
        # your code here
        random_idxs=np.random.permutation(len(audio_features))
        for idx in random_idxs:
            sorted_ids.append(audio_features[idx]['id'])
    

    return sorted_ids