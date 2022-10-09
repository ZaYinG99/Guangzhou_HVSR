import os
import numpy as np
from scipy import signal
def local_argmax(data):
    result = []
    for i in range(len(data)):
        if 4 < i < len(data) - 5 and data[i] > data[i-5] and data[i] > data[i+5]:
            result.append(i)
    return result

if __name__ == '__main__':
    os.chdir('./out_dir1')
    stalst = 'sta_lst_bad'
    with open(stalst, 'r') as f:
        lines = f.readlines()
        stas = list(map(lambda x: x.split()[0], lines))
    with open('sta_hvsr_bad', 'w') as f:
        for sta in stas:
            temp = np.loadtxt(sta)
            freqs, hvsrs = temp[:,0], temp[:,1]
            args = signal.find_peaks(hvsrs, prominence = 1)
            freqm = []
            hvsrm = []
            for arg in args[0]:
                if 0.1 < freqs[arg] < 20:
                    freqm.append(freqs[arg])
                    hvsrm.append(hvsrs[arg])
            if len(freqm) >= 1:
                idx = hvsrm.index(max(hvsrm))
                hvsr_max = hvsrm[idx]
                freq_max = freqm[idx]
                print(sta, end='', file = f)
                print(' ', end='', file = f)
                print(freq_max, end='', file = f)
                print(' ', end='', file = f)
                print(hvsr_max, file = f)



