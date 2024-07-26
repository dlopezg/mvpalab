%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'RSA';
cfg.location = pwd;

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

% Subjects:
cfg.rsa.subjects = {
    %'/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-001';
    %'/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-002';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-003';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-004';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-005';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-006';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-007';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-008';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-009';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-010';
    %'/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-011';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-012';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-013';
    %'/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-014';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-015';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-016';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-017';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-018';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-019';
    '/Volumes/DATA/att-exp/data/att-exp-fmri/derivatives/sub-020';
    };

cfg.study.SPMFolder = 'GLM_models/univariate';
cfg.study.maskFile = 'GLM_models/univariate/mask.nii';
%% REPRESENTATIONAL SIMILARITY ANALYSIS

cfg.rsa.distance = 'pearson';
cfg.rsa.analysis = 'corr';
cfg.rsa.trialwise = true;

%% SEARCHLIGHT CONFIGURATION:
cfg.sl.radius = 2;

%% BALANCED DATASETS:

cfg.classsize.match = false;

%% DATA NORMALIZATION:

% cfg.normdata = 0 - raw data
% cfg.normdata = 1 - z-score (across features)
% cfg.normdata = 2 - z-score (across time)
% cfg.normdata = 3 - z-score (across trials)
% cfg.normdata = 4 - std_nor (across trials)

cfg.normdata = 0; 

%% DATA SMOOTHING:

% cfg.smoothdata.method = 'none'   - Data smooth disabled.
% cfg.smoothdata.method = 'moving' - Moving average method.

cfg.smoothdata.method   = 'moving';
cfg.smoothdata.window   = 5;

%% ANALYSIS TIMING:

cfg.tm.tpstart   = -100;
cfg.tm.tpend     = 1500;
cfg.tm.tpsteps   = 1;

%% EXTRA CONFIGURATION:

cfg.classmodel.tempgen = false;
cfg.classmodel.parcomp = true;

%% PERMUTATION TEST

cfg.stats.flag   = 1;
cfg.stats.nper   = 10;
cfg.stats.nperg  = 1e4;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;
cfg.stats.tails  = 2;
cfg.stats.shownulldis = 1;
