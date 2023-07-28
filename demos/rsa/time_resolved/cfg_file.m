%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'demo-rsa';
cfg.location = pwd;

% Condition indentifiers:
cfg.study.conditionIdentifier{1,1} = 'val_name_exp';
cfg.study.conditionIdentifier{1,2} = 'val_name_att';
cfg.study.conditionIdentifier{1,3} = 'val_face_exp';
cfg.study.conditionIdentifier{1,4} = 'val_face_att';
cfg.study.conditionIdentifier{1,5} = 'inv_name_exp';
cfg.study.conditionIdentifier{1,6} = 'inv_name_att';
cfg.study.conditionIdentifier{1,7} = 'inv_face_exp';
cfg.study.conditionIdentifier{1,8} = 'inv_face_att';

% Condition folders:
cfg.study.dataPaths{1,1} = '/Users/David/Desktop/dataset/target_val_name_exp/';
cfg.study.dataPaths{1,2} = '/Users/David/Desktop/dataset/target_val_name_att/';
cfg.study.dataPaths{1,3} = '/Users/David/Desktop/dataset/target_val_face_exp/';
cfg.study.dataPaths{1,4} = '/Users/David/Desktop/dataset/target_val_face_att/';
cfg.study.dataPaths{1,5} = '/Users/David/Desktop/dataset/target_inv_name_exp/';
cfg.study.dataPaths{1,6} = '/Users/David/Desktop/dataset/target_inv_name_att/';
cfg.study.dataPaths{1,7} = '/Users/David/Desktop/dataset/target_inv_face_exp/';
cfg.study.dataPaths{1,8} = '/Users/David/Desktop/dataset/target_inv_face_att/';

% Subject files:
cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.dataFiles{1,3} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.dataFiles{1,4} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.dataFiles{1,5} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.dataFiles{1,6} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.dataFiles{1,7} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.dataFiles{1,8} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};

%% REPRESENTATIONAL SIMILARITY ANALYSIS:

cfg.rsa.modality = 'corr';
cfg.rsa.distance = 'euclidean';
cfg.rsa.trialwise = true;
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

%% TRIAL AVERAGE:

cfg.trialaver.flag     = true;
cfg.trialaver.ntrials  = 5;
cfg.trialaver.order    = 'rand';

% cfg.trialaver.order = 'rand' - Random order.
% cfg.trialaver.order = 'seq'  - Secuential order.

%% BALANCED DATASETS:

cfg.classsize.match = false;

%% DATA SMOOTHING:

% cfg.smoothdata.method = 'none'   - Data smooth disabled.
% cfg.smoothdata.method = 'moving' - Moving average method.

cfg.smoothdata.method   = 'gaussian';
cfg.smoothdata.window   = 5;

%% ANALYSIS TIMING:

cfg.tm.tpstart   = -100;
cfg.tm.tpend     = 1200;
cfg.tm.tpsteps   = 1;

%% EXTRA CONFIGURATION:

cfg.classmodel.parcomp = true;

%% PERMUTATION TEST

cfg.stats.flag   = 1;
cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e4;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;
cfg.stats.tails  = 2;
cfg.stats.shownulldis = 0;
