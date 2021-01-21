%% MVPAlab - Configuration file for MVCC analysis:

%% Data files and paths:

cfg.study.analysis = 'MVCC';
cfg.study.studyLocation = pwd;

cfg.study.conditionIdentifier{1,1} = 'condition_1';
cfg.study.conditionIdentifier{1,2} = 'condition_2';
cfg.study.conditionIdentifier{2,1} = 'condition_3';
cfg.study.conditionIdentifier{2,2} = 'condition_4';

cfg.study.dataPaths{1,1} = '/Users/David/Desktop/data/condition_1/';
cfg.study.dataPaths{1,2} = '/Users/David/Desktop/data/condition_2/';
cfg.study.dataPaths{2,1} = '/Users/David/Desktop/data/condition_3/';
cfg.study.dataPaths{2,2} = '/Users/David/Desktop/data/condition_4/';

cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{2,1} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{2,2} = {'1.mat','2.mat','3.mat'};

%% Configuration - Feature extraction:

% Supertrial generation:
cfg.trialaver.flag     = true;
cfg.trialaver.ntrials  = 3;
cfg.trialaver.order    = 'rand';

% Match data size to nfold:
cfg.classsize.match = true;
cfg.classsize.matchkfold = false;

%% Configuration - Feature selection:

cfg.dimred.method = 'pca';
cfg.dimred.flag   = false;
cfg.dimred.ncomp  = 1;

%% Configuration - classification analysis:

% Data smoothing:
cfg.smoothdata.flag     = true;
cfg.smoothdata.method   = 'movmean';
cfg.smoothdata.window   = 10;

% Notmalization methods:
% 0 - raw data
% 1 - z-score (across features)
% 2 - z-score (across time)
% 3 - z-score (across trials)
% 4 - std_nor (across trials)
cfg.normdata  = 4;

% Timming:
cfg.tm.tpstart  = -200;
cfg.tm.tpend    = 1500;
cfg.tm.tpsteps  = 3;

% Classification procedure:
cfg.classmodel.parcomp  = true;
cfg.classmodel.method   = 'svm';
cfg.classmodel.kernel   = 'linear';

% Temporal generalization:
cfg.classmodel.tempgen  = false;

% Additional performance metrics:
cfg.classmodel.confmat  = false;
cfg.classmodel.roc      = false;

% Configuration - Statistic for permutation method:
cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e4;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;
