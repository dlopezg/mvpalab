%% MVPAlab - configuration of the time-resolved RSA demo.
%  Only the settings of this demo: the rest keep the values of
%  mvpalab_init, where every option is documented.

cfg.analysis = 'rsa-time-resolved';

%% Data: one folder per condition, with the same subjects in each one.

cfg.study.conditionIdentifier{1,1} = 'val_name_exp';
cfg.study.dataPaths{1,1} = fullfile('data','target_val_name_exp');
cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.conditionIdentifier{1,2} = 'val_name_att';
cfg.study.dataPaths{1,2} = fullfile('data','target_val_name_att');
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.conditionIdentifier{1,3} = 'val_face_exp';
cfg.study.dataPaths{1,3} = fullfile('data','target_val_face_exp');
cfg.study.dataFiles{1,3} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.conditionIdentifier{1,4} = 'val_face_att';
cfg.study.dataPaths{1,4} = fullfile('data','target_val_face_att');
cfg.study.dataFiles{1,4} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.conditionIdentifier{1,5} = 'inv_name_exp';
cfg.study.dataPaths{1,5} = fullfile('data','target_inv_name_exp');
cfg.study.dataFiles{1,5} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.conditionIdentifier{1,6} = 'inv_name_att';
cfg.study.dataPaths{1,6} = fullfile('data','target_inv_name_att');
cfg.study.dataFiles{1,6} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.conditionIdentifier{1,7} = 'inv_face_exp';
cfg.study.dataPaths{1,7} = fullfile('data','target_inv_face_exp');
cfg.study.dataFiles{1,7} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};
cfg.study.conditionIdentifier{1,8} = 'inv_face_att';
cfg.study.dataPaths{1,8} = fullfile('data','target_inv_face_att');
cfg.study.dataFiles{1,8} = {'1.mat','2.mat','3.mat','4.mat','5.mat'};

%% Representational similarity analysis:

cfg.rsa.modality  = 'multiple_regress';
cfg.rsa.trialwise = false;
cfg.rsa.nfolds    = 3;

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

%% Supertrials, folds of the same size and normalization:

cfg.trialaver.flag       = true;
cfg.trialaver.ntrials    = 3;
cfg.classsize.matchkfold = true;
cfg.normdata             = 1;

%% Smoothing and timing:

cfg.smoothdata.method = 'gaussian';
cfg.smoothdata.window = 5;
cfg.tm.tpstart = -100;
cfg.tm.tpend   = 1200;

cfg.classmodel.parcomp = false;

%% Permutation test, run inside the analysis:

cfg.stats.flag = true;
% cfg.stats.signflip = true;  % Sign flip group test (see mvpalab_init).
