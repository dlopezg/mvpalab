%% MVPAlab - Configuration file for MVPA analysis:

%% Data files and paths:

cfg.analysis = 'MVPA';
cfg.study.studyLocation = pwd;

cfg.study.conditionIdentifier{1,1} = 'condition_a';
cfg.study.conditionIdentifier{1,2} = 'condition_b';

cfg.study.dataPaths{1,1} = '/Users/David/Desktop/data/condition_a/';
cfg.study.dataPaths{1,2} = '/Users/David/Desktop/data/condition_b/';

cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat'};

%% Configuration - Feature extraction:

% Supertrial generation:
cfg.trialaver.flag     = true;
cfg.trialaver.ntrials  = 5;
cfg.trialaver.order    = 'rand';

% Match data size to nfold:
cfg.classsize.match      = true;
cfg.classsize.matchkfold = true;

%% Configuration - Feature selection:

cfg.dimred.method = 'pca';
cfg.dimred.flag   = false;
cfg.dimred.ncomp  = 1;

%% Configuration - classification analysis:

% Data smoothing:
cfg.smoothdata.flag = true;
cfg.smoothdata.method = 'movmean';
cfg.smoothdata.window = 10;

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

% Cros-validation procedure:
cfg.cv.method  = 'kfold';
cfg.cv.nfolds  = 5;

% Classification model:
cfg.classmodel.parcomp  = true;
cfg.classmodel.method = 'svm';
cfg.classmodel.kernel = 'linear';

% Temporal generalization:
cfg.classmodel.tempgen  = true;

% Additional performance metrics:
cfg.classmodel.confmat  = false;
cfg.classmodel.roc      = false;

% Configuration - Statistic for permutation method:
cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e4;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;
