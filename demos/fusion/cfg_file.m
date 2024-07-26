%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'fusion_cue';
cfg.location = pwd;

%% FUSION:

cfg.fusion.mode = 'mean-fmri';
cfg.fusion.distance = 'pearson';
cfg.fusion.mode = 'searchlight';

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


%% Import RDMs Searchlight

for i = 1 : 2
    % subject folder is sl_sub_i
    subject_folder = ['/Users/David/Desktop/att-exp-fusion/fmri/cue/rdms/pearson/sl_sub_' num2str(i)];
    % import fmri searchlight data for sub i (in the folder sl_sub_i)
    temp = load([subject_folder '/rdms/result.mat'],'result');
    searchlight_rdms{i} = temp.result;

    % load the voxel coordinates of this subject
    temp_vc = load([subject_folder '/voxel_coordinates/result.mat'],'result');
    cfg.voxel_coordinates{i} = temp_vc.result;
end

%% Import RDMs EEG:

temp = load('/Users/David/Desktop/att-exp-fusion/eeg/cue/rdms/pearson/result.mat', 'result');
meeg_rdms = temp.result;

   

%% Update time vector:

cfg.tm.times = temp.cfg.tm.times;

%% EXTRA CONFIGURATION:

cfg.classmodel.parcomp = false;

%% PERMUTATION TEST

cfg.stats.flag   = 1;
cfg.stats.nper   = 10;
cfg.stats.nperg  = 1e4;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;
cfg.stats.tails  = 2;
cfg.stats.shownulldis = 0;
