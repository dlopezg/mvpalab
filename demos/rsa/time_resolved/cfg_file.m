%% Advacned configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'demo-rsa';
cfg.location = pwd;

% Condition indentifiers:
cfg.study.conditionIdentifier{1,1} = 'INT_ANIM_COLOR';
cfg.study.conditionIdentifier{1,2} = 'INT_ANIM_SHAPE';
cfg.study.conditionIdentifier{1,3} = 'INT_INAN_COLOR';
cfg.study.conditionIdentifier{1,4} = 'INT_INAN_SHAPE';
cfg.study.conditionIdentifier{1,5} = 'SEL_ANIM_COLOR';
cfg.study.conditionIdentifier{1,6} = 'SEL_ANIM_SHAPE';
cfg.study.conditionIdentifier{1,7} = 'SEL_INAN_COLOR';
cfg.study.conditionIdentifier{1,8} = 'SEL_INAN_SHAPE';

% Condition folders:
cfg.study.dataPaths{1,1} = '/Volumes/DATA/inst-comp/data/eeg/conditions/INT_ANIM_COLOR/';
cfg.study.dataPaths{1,2} = '/Volumes/DATA/inst-comp/data/eeg/conditions/INT_ANIM_SHAPE/';
cfg.study.dataPaths{1,3} = '/Volumes/DATA/inst-comp/data/eeg/conditions/INT_INAN_COLOR/';
cfg.study.dataPaths{1,4} = '/Volumes/DATA/inst-comp/data/eeg/conditions/INT_INAN_SHAPE/';
cfg.study.dataPaths{1,5} = '/Volumes/DATA/inst-comp/data/eeg/conditions/SEL_ANIM_COLOR/';
cfg.study.dataPaths{1,6} = '/Volumes/DATA/inst-comp/data/eeg/conditions/SEL_ANIM_SHAPE/';
cfg.study.dataPaths{1,7} = '/Volumes/DATA/inst-comp/data/eeg/conditions/SEL_INAN_COLOR/';
cfg.study.dataPaths{1,8} = '/Volumes/DATA/inst-comp/data/eeg/conditions/SEL_INAN_SHAPE/';

% Subject files:
cfg.study.dataFiles{1,1} = {
    'sub-001.mat'
    'sub-002.mat'
    'sub-003.mat'
    'sub-004.mat'
    'sub-005.mat'
    'sub-006.mat'
    'sub-007.mat'
    'sub-008.mat'
    'sub-009.mat'
    'sub-010.mat'
    'sub-011.mat'
    'sub-012.mat'
    'sub-013.mat'
    'sub-014.mat'
    'sub-015.mat'
    'sub-017.mat'
    'sub-018.mat'
    'sub-019.mat'
    'sub-020.mat'
    'sub-021.mat'
    'sub-022.mat'
    'sub-024.mat'
    'sub-025.mat'
    'sub-026.mat'
    'sub-027.mat'
    'sub-028.mat'
    'sub-029.mat'
    'sub-030.mat'
    'sub-031.mat'
    'sub-032.mat'
    'sub-033.mat'
    'sub-034.mat'
    'sub-035.mat'
    'sub-036.mat'
    'sub-037.mat'
    'sub-038.mat'
    'sub-039.mat'
    'sub-040.mat'
    'sub-041.mat'
    };

cfg.study.dataFiles{1,2} = cfg.study.dataFiles{1,1};
cfg.study.dataFiles{1,3} = cfg.study.dataFiles{1,1};
cfg.study.dataFiles{1,4} = cfg.study.dataFiles{1,1};
cfg.study.dataFiles{1,5} = cfg.study.dataFiles{1,1};
cfg.study.dataFiles{1,6} = cfg.study.dataFiles{1,1};
cfg.study.dataFiles{1,7} = cfg.study.dataFiles{1,1};
cfg.study.dataFiles{1,8} = cfg.study.dataFiles{1,1};

%% REPRESENTATIONAL SIMILARITY ANALYSIS:

cfg.rsa.modality = 'corr';
cfg.rsa.distance = 'pearson';
cfg.rsa.trialwise = false;
cfg.rsa.normrdm = true;

%% VECTORIZED THEORETHICAL MODELS:
                         %|          %|        %|      %|    %|  %| %| 
category  = [ 0 1 1 0 0 1 1 1 1 0 0 1 1 0 1 1 0 0 1 1 0 0 0 1 1 1 1 0];
feature   = [ 1 0 1 0 1 0 1 1 0 1 0 1 0 1 0 1 0 1 1 0 1 0 1 0 1 1 0 1];
task      = [ 0 0 0 1 1 1 1 0 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0];

cfg.rsa.tmodels{1}.id  = 'task_demand_model'; % INT VS SEL
cfg.rsa.tmodels{1}.mdl = squareform(task);

cfg.rsa.tmodels{2}.id  = 'target_category_model'; % ANIM VS INAN
cfg.rsa.tmodels{2}.mdl = squareform(category);

cfg.rsa.tmodels{3}.id  = 'target_relevant_feature'; % COLOR VS SHAPE
cfg.rsa.tmodels{3}.mdl = squareform(feature);

clear stimu block valid

%% TRIAL AVERAGE:

% cfg.trialaver.order = 'rand' - Random order.
% cfg.trialaver.order = 'seq'  - Secuential order.

cfg.trialaver.flag     = true;
cfg.trialaver.ntrials  = 5;
cfg.trialaver.order    = 'rand';



%% BALANCED DATASETS:

cfg.classsize.match = false;

%% DATA SMOOTHING:

% cfg.smoothdata.method = 'none'   - Data smooth disabled.
% cfg.smoothdata.method = 'moving' - Moving average method.

cfg.smoothdata.method   = 'gaussian';
cfg.smoothdata.window   = 5;

%% ANALYSIS TIMING:

cfg.tm.tpstart   = -100;
cfg.tm.tpend     = 7000;
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
