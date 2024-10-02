# any import? 

def compute_beats(y, sr):
    """This function uses librosa library to compute beats from an audio signal
    and returns the time index where the beats occur 

    Parameters
    
    ----------
    y : np.ndarray
        time-domain audio signal
    sr : int, float
        samplerate

    Returns
    -------
    np.ndarray
        sample index where beat occurs
    """
    # your code here
    return 0

def add_samples(y, sample, beats):
    """Add a sample to an audio signal at given beats 

    Parameters
    ----------
    y : np.ndarray
        the original signal
    sample : np.ndarray
        the sample beat to add
    beats : np.ndarray
        the time beats

    Returns
    -------
    np.ndarray
        original signal + sample on beats
    """
    y_out=y.copy()
    # your code here ...

    return y_out

