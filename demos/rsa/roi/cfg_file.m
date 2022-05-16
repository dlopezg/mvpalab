%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'rsa_roi';
cfg.location = pwd;

%% REPRESENTATIONAL SIMILARITY ANALYSIS:

% Subjects:
cfg.rsa.subjects = {
%     '/Users/David/Desktop/att-exp-fmri/derivatives/sub-001';
%     '/Users/David/Desktop/att-exp-fmri/derivatives/sub-002';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-003';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-004';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-005';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-006';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-007';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-008';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-009';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-010';
%     '/Users/David/Desktop/att-exp-fmri/derivatives/sub-011';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-012';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-013';
%     '/Users/David/Desktop/att-exp-fmri/derivatives/sub-014';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-015';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-016';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-017';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-018';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-019';
    '/Users/David/Desktop/att-exp-fmri/derivatives/sub-020';
    };

cfg.rsa.betafolder = 'GLM_models_decoding';

% Conditions:
cfg.rsa.conditions = {
    'target_Exp_Val_Word';
    'target_Att_Val_Word';
    'target_Exp_Val_Face';
    'target_Att_Val_Face';
    'target_Exp_Inval_Word';
    'target_Att_Inval_Word';
    'target_Exp_Inval_Face';
    'target_Att_Inval_Face';
    };

% Regions of interest:
cfg.rsa.roi = {
    'bin_rwVVC_bilateral.nii';
    'bin_rwM1_bilateral.nii';
    };

cfg.rsa.roi_folder = fullfile('anat','rois');

% Distance metric:
cfg.rsa.distance = 'pearson';

%% EXTRA CONFIGURATION:

cfg.classmodel.parcomp = true;

%% PERMUTATION TEST

cfg.stats.flag   = 1;
cfg.stats.nper   = 10;
cfg.stats.nperg  = 1e4;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;
cfg.stats.tails  = 2;
cfg.stats.shownulldis = 1;
