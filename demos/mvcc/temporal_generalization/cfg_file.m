
%% Basic configuration file for MVPA analysis - Folder and data files:

cfg.analysis = 'MVCC';
cfg.location = pwd;

cfg.study.conditionIdentifier{1,1} = 'condition_1';
cfg.study.conditionIdentifier{1,2} = 'condition_2';
cfg.study.conditionIdentifier{2,1} = 'condition_3';
cfg.study.conditionIdentifier{2,2} = 'condition_4';

cfg.study.dataPaths{1,1} = 'C:\Users\Cimcyc\Desktop\data\condition_1\';
cfg.study.dataPaths{1,2} = 'C:\Users\Cimcyc\Desktop\data\condition_2\';
cfg.study.dataPaths{2,1} = 'C:\Users\Cimcyc\Desktop\data\condition_3\';
cfg.study.dataPaths{2,2} = 'C:\Users\Cimcyc\Desktop\data\condition_4\';

cfg.study.dataFiles{1,1} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{1,2} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{2,1} = {'1.mat','2.mat','3.mat'};
cfg.study.dataFiles{2,2} = {'1.mat','2.mat','3.mat'};

%% Enable temporal generalization matrix:

cfg.classmodel.tempgen = true;
