%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'RSA';
cfg.location = pwd;

cfg.rsa.conditions = {
    'cue_Att_CueFace1';
    'cue_Att_CueFace2';
    'cue_Att_CueName1';
    'cue_Att_CueName2';
    'cue_Exp_CueFace1';
    'cue_Exp_CueFace2';
    'cue_Exp_CueName1';
    'cue_Exp_CueName2';
    };

cfg.study.SPMFolder = '/Volumes/DATA/att-exp-fmri/derivatives/sub-004/GLM_models_decoding';
cfg.study.maskFile = '/Volumes/DATA/att-exp-fmri/derivatives/sub-004/GLM_models_decoding/mask.nii';
%% REPRESENTATIONAL SIMILARITY ANALYSIS:

cfg.rsa.distance = 'pearson';
cfg.rsa.analysis = 'corr';
cfg.rsa.trialwise = true;

%% SEARCHLIGHT CONFIGURATION:
cfg.sl.radius = 4;

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
