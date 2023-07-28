%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'prueba';
cfg.location = pwd;

%% REPRESENTATIONAL SIMILARITY ANALYSIS:

% Subjects:
cfg.rsa.subjects = {
    %     '/Volumes/DATA/att-exp-fmri/derivatives/sub-001';
    %     '/Volumes/DATA/att-exp-fmri/derivatives/sub-002';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-003';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-004';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-005';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-006';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-007';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-008';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-009';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-010';
    %     '/Volumes/DATA/att-exp-fmri/derivatives/sub-011';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-012';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-013';
    %     '/Volumes/DATA/att-exp-fmri/derivatives/sub-014';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-015';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-016';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-017';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-018';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-019';
    '/Volumes/DATA/att-exp-fmri/derivatives/sub-020';
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

% cfg.rsa.conditions = {
%     'cue_Att_CueFace1';
%     'cue_Att_CueFace2';
%     'cue_Att_CueName1';
%     'cue_Att_CueName2';
%     'cue_Exp_CueFace1';
%     'cue_Exp_CueFace2';
%     'cue_Exp_CueName1';
%     'cue_Exp_CueName2';
%     };


% Regions of interest:
cfg.rsa.roi = {
    'bin_rwVVC_bilateral.nii';
    'bin_rwM1_bilateral.nii';
    %     'bin_rwA1_bilateral.nii';
    %     'bin_rwPSL_bilateral.nii';
    %     'bin_rwRSC_bilateral.nii';
    %     'bin_rwSFL_bilateral.nii';
    };

cfg.rsa.roi_folder = fullfile('anat','rois');

% Distance metric:
cfg.rsa.modality = 'corr';
cfg.rsa.distance = 'euclidean';
cfg.rsa.normrdm = true;

%% VECTORIZED THEORETHICAL MODELS:
                     %|          %|        %|      %|    %|  %| %| 
stimu = [ 0 1 1 0 0 1 1 1 1 0 0 1 1 0 1 1 0 0 1 1 0 0 0 1 1 1 1 0];
block = [ 1 0 1 0 1 0 1 1 0 1 0 1 0 1 0 1 0 1 1 0 1 0 1 0 1 1 0 1];
valid = [ 0 0 0 1 1 1 1 0 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0];

cfg.rsa.tmodels{1}.id  = 'stimuli_model';
cfg.rsa.tmodels{1}.mdl = squareform(stimu);

cfg.rsa.tmodels{2}.id  = 'block_model';
cfg.rsa.tmodels{2}.mdl = squareform(block);

cfg.rsa.tmodels{3}.id  = 'validity_model';
cfg.rsa.tmodels{3}.mdl = squareform(valid);

clear stimu block valid

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
