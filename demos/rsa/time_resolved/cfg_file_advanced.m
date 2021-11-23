%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'RSA';
cfg.location = pwd;

% Condition indentifiers:
cfg.study.conditionIdentifier{1,1} = 'cue_at_name_1';
cfg.study.conditionIdentifier{1,2} = 'cue_at_name_2';
cfg.study.conditionIdentifier{1,3} = 'cue_ex_name_1';
cfg.study.conditionIdentifier{1,4} = 'cue_ex_name_2';
cfg.study.conditionIdentifier{1,5} = 'cue_at_face_1';
cfg.study.conditionIdentifier{1,6} = 'cue_at_face_2';
cfg.study.conditionIdentifier{1,7} = 'cue_ex_face_1';
cfg.study.conditionIdentifier{1,8} = 'cue_ex_face_2';

% Data paths:
cfg.study.dataPaths{1,1} = '/Users/David/Desktop/conditions/cue_at_name_1/';
cfg.study.dataPaths{1,2} = '/Users/David/Desktop/conditions/cue_at_name_2/';
cfg.study.dataPaths{1,3} = '/Users/David/Desktop/conditions/cue_ex_name_1/';
cfg.study.dataPaths{1,4} = '/Users/David/Desktop/conditions/cue_ex_name_2/';
cfg.study.dataPaths{1,5} = '/Users/David/Desktop/conditions/cue_at_face_1/';
cfg.study.dataPaths{1,6} = '/Users/David/Desktop/conditions/cue_at_face_2/';
cfg.study.dataPaths{1,7} = '/Users/David/Desktop/conditions/cue_ex_face_1/';
cfg.study.dataPaths{1,8} = '/Users/David/Desktop/conditions/cue_ex_face_2/';

% Data files:
cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,3} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,4} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,5} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,6} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,7} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,8} = {'1.mat','2.mat','3.mat'};

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

cfg.trialaver.flag     = false;
cfg.trialaver.ntrials  = 0;
cfg.trialaver.order    = 'rand';

% cfg.trialaver.order = 'rand' - Random order.
% cfg.trialaver.order = 'seq'  - Secuential order.

%% BALANCED DATASETS:

cfg.classsize.match = true;

%% DIMENSION REDUCTION:

% cfg.dimred.method = 'none' - Diemnsion reduction disabled.
% cfg.dimred.method = 'pca'  - Principal Component Analysis.

cfg.dimred.method = 'none';
cfg.dimred.ncomp  = 0;

%% DATA NORMALIZATION:

% cfg.normdata = 0 - raw data
% cfg.normdata = 1 - z-score (across features)
% cfg.normdata = 2 - z-score (across time)
% cfg.normdata = 3 - z-score (across trials)
% cfg.normdata = 4 - std_nor (across trials)

cfg.normdata = 0; 

%% DATA SMOOTHING:

% cfg.smoothdata.method = 'none'   - Data smooth disabled.
% cfg.smoothdata.method = 'moving' - Moving average method.

cfg.smoothdata.method   = 'none';
cfg.smoothdata.window   = 1;

%% ANALYSIS TIMING:

cfg.tm.tpstart   = 0;
cfg.tm.tpend     = 0;
cfg.tm.tpsteps   = 1;


%% EXTRA CONFIGURATION:

cfg.classmodel.tempgen = false;
cfg.classmodel.parcomp = false;
cfg.classmodel.permlab = false;

%% CROSS-VALIDATIONN PROCEDURE:

% cfg.cv.method = 'kfold' - K-Fold cross-validation.
% cfg.cv.method = 'loo'   - Leave-one-out cross-validation.

cfg.cv.method  = 'kfold';
cfg.cv.nfolds  = 5;

%% PERMUTATION TEST

cfg.stats.flag   = 0;
cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e5;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;
cfg.stats.shownulldis = 0;
