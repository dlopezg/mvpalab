
%% Basic configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'MVPA';
cfg.location = pwd;

% Condition indentifiers:
cfg.study.conditionIdentifier{1,1} = 'condition_a';
cfg.study.conditionIdentifier{1,2} = 'condition_b';

% Data paths:
cfg.study.dataPaths{1,1} = 'C:\Users\Cimcyc\Desktop\data\condition_a\';
cfg.study.dataPaths{1,2} = 'C:\Users\Cimcyc\Desktop\data\condition_b\';

% Data files:
cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat'};

%% Enable temporal generalization matrix:

cfg.classmodel.tempgen = true;
