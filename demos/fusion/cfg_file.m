%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'fusion_cue';
cfg.location = pwd;

%% FUSION:

cfg.fusion.mode = 'mean-fmri';
cfg.fusion.distance = 'pearson';

%% Import RDMs FMRI:

temp = load('/Users/David/Desktop/att-exp-fusion/fmri/cue/rdms/pearson/bin_rwM1_bilateral/result.mat','result');
fmri_rdms.bin_rwM1_bilateral = temp.result;

temp = load('/Users/David/Desktop/att-exp-fusion/fmri/cue/rdms/pearson/bin_rwVVC_bilateral/result.mat','result');
fmri_rdms.bin_rwVVC_bilateral = temp.result;

% temp = load('/Users/David/Desktop/att-exp-fusion/fmri/cue/rdms/pearson/bin_rwA1_bilateral/result.mat','result');
% fmri_rdms.bin_rwA1_bilateral = temp.result;
% 
% temp = load('/Users/David/Desktop/att-exp-fusion/fmri/cue/rdms/pearson/bin_rwPSL_bilateral/result.mat','result');
% fmri_rdms.bin_rwPSL_bilateral = temp.result;
% 
% temp = load('/Users/David/Desktop/att-exp-fusion/fmri/cue/rdms/pearson/bin_rwRSC_bilateral/result.mat','result');
% fmri_rdms.bin_rwRSC_bilateral = temp.result;
% 
% temp = load('/Users/David/Desktop/att-exp-fusion/fmri/cue/rdms/pearson/bin_rwSFL_bilateral/result.mat','result');
% fmri_rdms.bin_rwSFL_bilateral = temp.result;

%% Import RDMs EEG:

temp = load('/Users/David/Desktop/att-exp-fusion/eeg/cue/rdms/pearson/result.mat');
meeg_rdms = temp.result;

%% Update time vector:

cfg.tm.times = temp.cfg.tm.times;

%% EXTRA CONFIGURATION:

cfg.classmodel.parcomp = true;

%% PERMUTATION TEST

cfg.stats.flag   = 1;
cfg.stats.nper   = 10;
cfg.stats.nperg  = 1e4;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;
cfg.stats.tails  = 2;
cfg.stats.shownulldis = 0;
