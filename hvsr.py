
import os
import obspy
from scipy import fftpack
from obspy.signal.util import next_pow_2
import numpy as np
import scipy
from scipy.signal import detrend, hann
from os.path import join
import matplotlib as mpl

# 如果遇到画图问题，注释掉下一行，这是为了在服务器上后台画图用的
mpl.use('Agg')
import matplotlib.pyplot as plt


def read_sac(path_sac):
    tr = obspy.read(path_sac)[0]
    tr.data = tr.data - np.mean(tr.data)
    tr.data = detrend(tr.data, type='linear')
    tr.taper(type='hann', max_percentage=0.05)
    return tr


def get_amp_spec(data):
    # taper
    taper_hann(data, 0.05)
    nfft = next_pow_2(len(data))
    # nfft = len(tr.data)
    fft = fftpack.fft(data, nfft)
    return np.abs(fft)[:len(fft)//2]


def calc_hvsr(pn, pe, pz, win_len=60, isplot=False):
    """
    :param pn: path to n component sac file
    :param pe: path to e component sac file
    :param pz: path to z component sac file
    :param win_len: length of every segment (second)
    :param isplot: whether plot
    :return: hvsr, frequency
    """
    tn = read_sac(pn)
    te = read_sac(pe)
    tz = read_sac(pz)
    delta = tz.stats.delta
    wn = int(win_len // delta)
    freq = fftpack.fftfreq(next_pow_2(wn), delta)
    freq = freq[:len(freq)//2]
    KO = KO_smooth_matrix(freq, 15)
 #   if not (len(tn.data) == len(te.data) == len(tz.data)):
 #       raise ValueError("need same length of three components")
    cur = 0
    hvsrs = []
    list_compare = [len(tn.data),len(te.data),len(tz.data)]
    while cur + wn < min(list_compare):
        fn = get_amp_spec(tn.data[cur:cur+wn])
        fe = get_amp_spec(te.data[cur:cur+wn])
        fz = get_amp_spec(tz.data[cur:cur+wn])
        ratio = np.sqrt((fn**2 + fe**2) / (2 * fz**2))
        ratio = KO.dot(ratio)
        hvsrs.append(ratio)
        cur += wn
    hvsrs = np.array(hvsrs)
    hvsr = hvsrs.mean(axis=0)
#    mask = (freq > 0.1) & (freq < 5)
#    freq = freq[mask]
#    hvsr = hvsr[mask]
    if isplot:
        mask = (freq > 0.1) & (freq < 100)
        pfreq = freq[mask]
        phvsr = hvsr[mask]
        plt.xlabel("Frequency(Hz)")
        plt.ylabel("HVSR")
        plt.xscale('log')
        plt.plot(pfreq, phvsr)
        plt.show()
    return hvsr, freq


def taper_hann(data, max_percentage=0.05):
    win_len = int(max_percentage * 2 * len(data))
    win = hann(win_len)
    mid = win_len // 2
    rdata = data.copy()
    mask = np.ones(len(data))
    mask[:mid] = win[:mid]
    mask[-mid:] = win[-mid:]
    rdata *= mask
    return rdata


def KO_smooth_matrix(freq, b):
    """
    Konno and Ohmachi 1998
    """
    freq = freq.copy()
    # TODO 避免分母或log为0, 注意这里可能有问题
    if freq[0] == 0:
        freq[0] = 0.01
    mat = []
    for f in freq:
        mat.append((np.sin(np.log10((freq/f)**b))/np.log10((freq/f)**b))**4)
    mat = np.array(mat)
    mat[np.isnan(mat)] = 1
    # 归一化
    for i in range(len(mat)):
        mat[i] /= np.sum(mat[i])
    return mat


def local_argmax(data):
    result = []
    for i in range(len(data)):
        if 0 < i < len(data) - 1 and data[i] > data[i-1] and data[i] > data[i+1]:
            result.append(i)
    return result


def do_folders(sta_lst, out_dir):
    FMIN, FMAX = 0.1, np.inf
    with open(sta_lst, 'r') as f:
        lines = f.readlines()
        stas = list(map(lambda x: x.split()[0], lines))
    for sta in stas:
        hvsrs, freqs = [], []
        try:
            temp1 = sta
            temp2 = sta[0:6]
            pn = '/mnt/2021_Greatbay3D_SAC_50sps/L2-Zland-130_perday/'+temp1+'/BP.'+temp2+'.00.SHN.D.2021.012.000000.SAC'
            pe = '/mnt/2021_Greatbay3D_SAC_50sps/L2-Zland-130_perday/'+temp1+'/BP.'+temp2+'.00.SHE.D.2021.012.000000.SAC'
            pz = '/gmnt/2021_Greatbay3D_SAC_50sps/L2-Zland-130_perday/'+temp1+'/BP.'+temp2+'.00.SHZ.D.2021.012.000000.SAC'
            hvsrs, freqs = calc_hvsr(pn, pe, pz, isplot=False)
        except FileNotFoundError:
            print("file not found error %s" % pn)
        hvsrs = np.array(hvsrs)
        freqs = np.array(freqs)
        f = freqs
        h_mean = hvsrs
        args = local_argmax(h_mean)
        np.savetxt(join(out_dir, sta), np.c_[f, h_mean], fmt='%.3f')
        plt.xlabel("Frequency (Hz)")
        plt.ylabel("HVSR")
        plt.xscale('log')
        plt.xlim((0.1,25))
        plt.plot(f, h_mean, 'red')
        plt.title('%s' % sta)
        for arg in args:
            plt.annotate('f=%.2fHz' % f[arg], xy=(f[arg], h_mean[arg]))
        plt.savefig(join(out_dir, sta+'.jpg'))
        plt.close()


def plot_slice(result_dir, sta_lst, lalo1, lalo2, width, line_name, fmin, fmax):
    from Geopy import utils
    # parameter
    vs = 500
    m = 0.08
    FMIN, FMAX = fmin, fmax

    fig, ax = plt.subplots()
    #ax2 = ax.twinx()
    ax.set_xlabel('Distance (km)')
    ax.set_ylabel('Depth (m)')
    plt.ylim(0,200)
    ax.invert_yaxis()
    ax.set_title("Profile: %s" % line_name)
    #ax2.set_ylabel('Frequency (Hz)')
    stas = utils.project_station(sta_lst, lalo1, lalo2, width)
    for line in stas:
        name, dist = line
        # name = name.split(':')[1]
        temp = np.loadtxt(join(result_dir, name))
        f, r = temp[:, 0], temp[:, 1]
        mask = (f < FMAX) & (f > FMIN)
        f, r = f[mask], r[mask]
        h = vs / (4.0 * f)
        r = r - np.mean(r)
        r = r / np.max(r) * m + dist
        ax.plot(r, h, color='black')
        ax.fill_betweenx(h[r > dist], dist, r[r > dist], color='red')
    plt.savefig('hvsr_slice_%s.jpg' % line_name)


if __name__ == '__main__':
    # 这是计算单个台站的函数，修改文件路径即可
    #pn, pe, pz = './001.02_08.05.N.SAC_RESP', './001.02_08.05.E.SAC_RESP','./001.02_08.05.V.SAC_RESP'
    #calc_hvsr(pn, pe, pz, win_len=60, isplot=True)
    #plot_slice('./out_dir', './sta_info_test',  (32.11440253, 118.95121042), (32.11559875, 118.95914937), 0.8, 'Line_test', 0.1,np.inf)
    # 这是遍历所有台站的函数，注意文件夹结构，及sac文件后缀，可能需要按照实际情况调整
#    os.chdir('/guangdong/2021_Greatbay3D_SAC_50sps/L2-Zland-130_perday/BP0003_ZLAND4310') 
    do_folders('/work/huang_zhouyuan/guangdong_HV/L2-ZLAND/sta_L2-ZLAND.txt', './out_dir/')
#    calc_hvsr('BP.BP0003.00.SHN.D.2021.004.000000.SAC','BP.BP0003.00.SHE.D.2021.004.000000.SAC','BP.BP0003.00.SHZ.D.2021.004.000000.SAC',win_len=60,isplot=True)