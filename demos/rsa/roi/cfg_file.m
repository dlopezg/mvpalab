%% MVPAlab - configuration of the fMRI RSA in regions of interest demo.
%  Only the settings of this demo: the rest keep the values of
%  mvpalab_init, where every option is documented.

cfg.analysis = 'rsa-roi';

%% Subjects and betas (sub-001, sub-002, sub-011 and sub-014 are left out):

folder = fullfile('data','derivatives');
cfg.rsa.subjects = fullfile(folder,{
    'sub-003';
    'sub-004';
    'sub-005';
    'sub-006';
    'sub-007';
    'sub-008';
    'sub-009';
    'sub-010';
    'sub-012';
    'sub-013';
    'sub-015';
    'sub-016';
    'sub-017';
    'sub-018';
    'sub-019';
    'sub-020';
    });
cfg.rsa.betafolder = 'GLM_models_decoding';

%% Conditions and regions of interest:

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

cfg.rsa.roi = {
    'bin_rwVVC_bilateral.nii';
    'bin_rwM1_bilateral.nii';
    'bin_rwA1_bilateral.nii';
    'bin_rwPSL_bilateral.nii';
    'bin_rwRSC_bilateral.nii';
    'bin_rwSFL_bilateral.nii';
    };
cfg.rsa.roi_folder = fullfile('anat','rois');

cfg.rsa.distance = 'euclidean';

%% Theoretical models (vectorized RDMs of the 8 conditions):

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

%% Permutation test, run inside the analysis:

cfg.stats.flag = true;
cfg.stats.nper = 10;  % Few permutations so the demo runs fast; use at least 100.
cfg.stats.shownulldis = true;
% cfg.stats.signflip = true;  % Sign flip group test (see mvpalab_init).
