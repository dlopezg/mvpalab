
%% Basic configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'MVPA';
cfg.location = pwd;

% Condition indentifiers:
cfg.study.conditionIdentifier{1,1} = 'condition_a';
cfg.study.conditionIdentifier{1,2} = 'condition_b';

% Data paths:
cfg.study.dataPaths{1,1} = 'M:\effort_choice\data\conditions\mat\tar_con\';
cfg.study.dataPaths{1,2} = 'M:\effort_choice\data\conditions\mat\tar_inc\';

% Data files:
cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat','4.mat','5.mat',...
    '6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat',...
    '14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat',...
    '22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat',...
    '30.mat','31.mat','32.mat'};

cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat','4.mat','5.mat',...
    '6.mat','7.mat','8.mat','9.mat','10.mat','11.mat','12.mat','13.mat',...
    '14.mat','15.mat','16.mat','17.mat','18.mat','19.mat','20.mat','21.mat',...
    '22.mat','23.mat','24.mat','25.mat','26.mat','27.mat','28.mat','29.mat',...
    '30.mat','31.mat','32.mat'};

%% FEATURE EXTRACTION:

cfg.feature = 'voltage';

% cfg.feature = 'voltage'  - Raw voltage as feature.
% cfg.feature = 'envelope' - Power evelope as feature.

cfg.powenv.method = 'analytic';
cfg.powenv.uplow  = 'upper';
cfg.powenv.length = 5;

% cfg.powenv.method = 'analytic' - Envelope using the analytic signal.
% cfg.powenv.method = 'peak'     - Peak envelopes.

% cfg.powenv.uplow = 'upper' - Select upper envelope.
% cfg.powenv.uplow = 'lower' - Select lower envelope.

%% TRIAL AVERAGE:

cfg.trialaver.flag     = true;
cfg.trialaver.ntrials  = 8;
cfg.trialaver.order    = 'rand';

% cfg.trialaver.order = 'rand' - Random order.
% cfg.trialaver.order = 'seq'  - Secuential order.

%% BALANCED DATASETS:

cfg.classsize.match = false;
cfg.classsize.matchkfold = false;

%% DIMENSION REDUCTION:

% cfg.dimred.method = 'none' - Diemnsion reduction disabled.
% cfg.dimred.method = 'pca'  - Principal Component Analysis.

cfg.dimred.method = 'pca';
cfg.dimred.ncomp  = 3;

%% DATA NORMALIZATION:

% cfg.normdata = 0 - raw data
% cfg.normdata = 1 - z-score (across features)
% cfg.normdata = 2 - z-score (across time)
% cfg.normdata = 3 - z-score (across trials)
% cfg.normdata = 4 - std_nor (across trials)

cfg.normdata = 4; 

%% DATA SMOOTHING:

% cfg.smoothdata.method = 'none'   - Data smooth disabled.
% cfg.smoothdata.method = 'moving' - Moving average method.

cfg.smoothdata.method   = 'moving';
cfg.smoothdata.window   = 5;

%% ANALYSIS TIMING:

cfg.tm.tpstart   = -100;
cfg.tm.tpend     = 1500;
cfg.tm.tpsteps   = 3;

%% CLASSIFICATION ALGORITHM:

% cfg.classmodel.method = 'svm' - Support Vector Machine.
% cfg.classmodel.method = 'da'  - Linear Discriminant Analysis.

% cfg.classmodel.kernel = 'linear'     - Support Vector Machine.
% cfg.classmodel.kernel = 'gaussian'   - Support Vector Machine.
% cfg.classmodel.kernel = 'rbf'        - Support Vector Machine.
% cfg.classmodel.kernel = 'polynomial' - Support Vector Machine.

% cfg.classmodel.kernel = 'linear' - Discriminant Analysis.
% cfg.classmodel.kernel = 'quadratic' - Discriminant Analysis.

cfg.classmodel.method = 'svm';
cfg.classmodel.kernel = 'linear';

%% HYPERPARAMETERS OPTIMIZATION:

cfg.classmodel.optimize.flag = false;
cfg.classmodel.optimize.params = {'BoxConstraint'};
cfg.classmodel.optimize.opt = struct('Optimizer','gridsearch',...
    'ShowPlots',false,'Verbose',0,'Kfold', 5);

%% PERFORMANCE METRICS:

cfg.classmodel.roc       = false;
cfg.classmodel.auc       = false;
cfg.classmodel.confmat   = false;
cfg.classmodel.precision = false;
cfg.classmodel.recall    = false;
cfg.classmodel.f1score   = false;
cfg.classmodel.wvector   = false;

%% EXTRA CONFIGURATION:

cfg.classmodel.tempgen = false;
cfg.classmodel.extdiag = false;
cfg.classmodel.parcomp = true;
cfg.classmodel.permlab = false;

%% CROSS-VALIDATIONN PROCEDURE:

% cfg.cv.method = 'kfold' - K-Fold cross-validation.
% cfg.cv.method = 'loo'   - Leave-one-out cross-validation.

cfg.cv.method  = 'kfold';
cfg.cv.nfolds  = 5;
