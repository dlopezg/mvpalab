%% MVPAlab - configuration of the MVCC sliding filter demo.
%  Only the settings of this demo: the rest keep the values of
%  mvpalab_init, where every option is documented.

%% Data: one folder per class, with the same subjects in each one.
%  Dataset A (first row) and dataset B (second row) make it an MVCC.

cfg.study.conditionIdentifier{1,1} = 'condition_1';
cfg.study.dataPaths{1,1} = fullfile('data','condition_1');
cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat'};
cfg.study.conditionIdentifier{1,2} = 'condition_2';
cfg.study.dataPaths{1,2} = fullfile('data','condition_2');
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat'};
cfg.study.conditionIdentifier{2,1} = 'condition_3';
cfg.study.dataPaths{2,1} = fullfile('data','condition_3');
cfg.study.dataFiles{2,1} = {'1.mat','2.mat','3.mat'};
cfg.study.conditionIdentifier{2,2} = 'condition_4';
cfg.study.dataPaths{2,2} = fullfile('data','condition_4');
cfg.study.dataFiles{2,2} = {'1.mat','2.mat','3.mat'};

%% Supertrials, balanced classes and normalization:

cfg.trialaver.flag    = true;
cfg.trialaver.ntrials = 3;
cfg.classsize.match   = true;
cfg.normdata          = 4;

%% Smoothing and timing:

cfg.smoothdata.method = 'moving';
cfg.smoothdata.window = 5;
cfg.tm.tpstart = -200;
cfg.tm.tpend   = 1500;
cfg.tm.tpsteps = 3;

%% Sliding filter:

cfg.sf.flag = true;
cfg.sf.filesLocation = fullfile(cfg.location,'filtered_datasets');
cfg.sf.hfreq = 20;
cfg.sf.order = 2408;
cfg.sf.nfreq = 5;

%% Permutation test, run inside the analysis:

cfg.stats.flag = true;
cfg.stats.nper = 10;  % Few permutations so the demo runs fast; use at least 100.
% cfg.stats.signflip = true;  % Sign flip group test (see mvpalab_init).
