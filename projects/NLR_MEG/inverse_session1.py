# -*- coding: utf-8 -*-
"""
Created on Tue Nov 15 12:05:40 2016

@author: sjjoo
"""

import sys
import mne
import matplotlib.pyplot as plt
from mne.utils import run_subprocess, logger
import os
from os import path as op
import copy
import shutil
import numpy as np
from numpy.random import randn
from scipy import stats as stats
import time
from functools import partial

from mne import set_config
set_config('MNE_MEMMAP_MIN_SIZE', '1M')
set_config('MNE_CACHE_DIR', '.tmp')

mne.set_config('MNE_USE_CUDA', 'true')

this_env = copy.copy(os.environ)
#fs_dir = '/mnt/diskArray/projects/freesurfer'
fs_dir = '/mnt/diskArray/projects/avg_fsurfer'

this_env['SUBJECTS_DIR'] = fs_dir
#this_env['FREESURFER_HOME'] = '/usr/local/freesurfer'

raw_dir = '/mnt/scratch/NLR_MEG3'

os.chdir(raw_dir)

subs = ['NLR_102_RS','NLR_103_AC','NLR_105_BB','NLR_110_HH','NLR_127_AM',
        'NLR_130_RW','NLR_132_WP','NLR_133_ML','NLR_145_AC','NLR_150_MG','NLR_151_RD',
        'NLR_152_TC','NLR_160_EK','NLR_161_AK','NLR_162_EF','NLR_163_LF','NLR_164_SF',
        'NLR_170_GM','NLR_172_TH','NLR_174_HS','NLR_179_GM','NLR_180_ZD','NLR_187_NB',
        'NLR_201_GS','NLR_202_DD','NLR_203_AM','NLR_204_AM','NLR_205_AC','NLR_206_LM',
        'NLR_207_AH','NLR_210_SB','NLR_211_LB'
        ]

#for n, s in enumerate(subs):
#    run_subprocess(['mne', 'watershed_bem', '--subject', subs[n],
#                 '--overwrite'], env=this_env)
#    mne.bem.make_watershed_bem(subject = subs[28],subjects_dir=fs_dir,overwrite=True,
#                               preflood=20, show=True)
"""USE THIS INSTEAD
mri_watershed -h 3 -useSRAS -surf /mnt/diskArray/projects/avg_fsurfer/NLR_205_AC/bem/watershed/NLR_205_AC /mnt/diskArray/projects/avg_fsurfer/NLR_205_AC/mri/T1.mgz /mnt/diskArray/projects/avg_fsurfer/NLR_205_AC/bem/watershed/ws
"""

# Let's take a look...
#for n, s in enumerate(subs):
#    mne.viz.plot_bem(subject=subs[n],subjects_dir=fs_dir,brain_surfaces='white', orientation='coronal')

#for n, s in enumerate(subs):
#    run_subprocess(['mne', 'make_scalp_surfaces', '--subject', subs[n],
#                    '--overwrite','--no-decimate']) # Disable medium and sparse decimations (dense only)
                                                    # otherwise, it gives errors

""" Co-register...
mne.gui.coregistration(tabbed=False,subject=subject,subjects_dir=fs_dir)
# Recommended way is to use mne coreg from terminal
"""

# Session 1
# subs are synced up with session1 folder names...
#
session1 = ['102_rs160618','102_rs160815','103_ac150609','105_bb150713','105_bb161011',
            '110_hh160608','110_hh160809','127_am151022','127_am161004','130_rw151221',
            '132_wp151117','132_wp160919','132_wp161122','133_ml151124','145_ac160621','145_ac160823',
            '150_mg160606','150_mg160825','151_rd160620','152_tc160422','152_tc160623','160_ek160627',
            '160_ek160915','161_ak160627','161_ak160916','162_ef160829','163_lf160707','163_lf160920',
            '164_sf160707','164_sf160920','170_gm160613','170_gm160822','172_th160614','172_th160825',
            '174_hs160620','174_hs160829','179_gm160701','179_gm160913','180_zd160621','180_zd160826',
            '187_nb161017','201_gs150729','201_gs150925','202_dd150919','202_dd151103','203_am150831',
            '203_am151029','204_am150829','204_am151120','205_ac151208','205_ac160202','206_lm151119',
            '206_lm160113','207_ah160608','207_ah160809','210_sb160822','211_lb160617','211_lb160823'
            ]

n_subjects = len(subs)

for n, s in enumerate(session1):
    os.chdir(os.path.join(raw_dir,session1[n]))
    
    subject = 'NLR_' + s[0:6].upper()
    
    os.chdir('forward')
    
    # Now read forward model
    fn = session1[n] + '-fwd.fif'
    fwd = mne.read_forward_solution(fn)

    #Inverse here
    os.chdir('../covariance')
    fn = session1[n] + '-40-sss-cov.fif'
    cov = mne.read_cov(fn)
    
    os.chdir('../inverse')
    fn = 'All_40-sss_eq_'+session1[n]+'-ave.fif'
    evoked = mne.read_evokeds(fn, condition=0, 
                              baseline=(None,0), kind='average', proj=True)
    
    info = evoked.info
    
    inv = mne.minimum_norm.make_inverse_operator(info, fwd, cov, loose=0.2, depth=0.8)
    
    fn = session1[n] + '-inv.fif'
    mne.minimum_norm.write_inverse_operator(fn,inv)
