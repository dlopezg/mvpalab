%% MVPAlab - configuration of the fMRI RSA searchlight demo.
%  Only the settings of this demo: the rest keep the values of
%  mvpalab_init, where every option is documented.

cfg.analysis = 'RSA';

%% Betas, mask and conditions of the subject:

folder = fullfile('data','derivatives','sub-004','GLM_models_decoding');
cfg.study.SPMFolder = folder;
cfg.study.maskFile = fullfile(folder,'mask.nii');

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

%% Smoothing and timing:

cfg.smoothdata.method = 'moving';
cfg.smoothdata.window = 5;
cfg.tm.tpstart = -100;
cfg.tm.tpend   = 1500;

%% Permutation test, run inside the analysis:

cfg.stats.flag = true;
cfg.stats.nper = 10;  % Few permutations so the demo runs fast; use at least 100.
cfg.stats.shownulldis = true;
% cfg.stats.signflip = true;  % Sign flip group test (see mvpalab_init).
