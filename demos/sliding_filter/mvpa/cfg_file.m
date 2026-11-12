%% MVPAlab - configuration of the MVPA sliding filter demo.
%  Only the settings of this demo: the rest keep the values of
%  mvpalab_init, where every option is documented.

%% Data: one folder per class, with the same subjects in each one.

cfg.study.conditionIdentifier{1,1} = 'condition_a';
cfg.study.dataPaths{1,1} = fullfile('data','condition_a');
cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat'};
cfg.study.conditionIdentifier{1,2} = 'condition_b';
cfg.study.dataPaths{1,2} = fullfile('data','condition_b');
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat'};

%% Supertrials, balanced classes and normalization:

cfg.trialaver.flag    = true;
cfg.trialaver.ntrials = 5;
cfg.classsize.match   = true;
cfg.classsize.matchkfold = true;
cfg.normdata          = 4;

%% Smoothing and timing:

cfg.smoothdata.method = 'moving';
cfg.smoothdata.window = 5;
cfg.tm.tpstart = -100;
cfg.tm.tpend   = 1200;
cfg.tm.tpsteps = 3;

%% Sliding filter:

cfg.sf.flag = true;
cfg.sf.filesLocation = fullfile(cfg.location,'filtered_datasets');
cfg.sf.hfreq = 20;
cfg.sf.order = 2408;

%% Permutation test, run inside the analysis:

cfg.stats.flag = true;
% cfg.stats.signflip = true;  % Sign flip group test (see mvpalab_init).
