
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

%% Permutation analysis:
cfg.stats.flag = true;

%% Sliding filter analysis configuration:

cfg.sf.flag = 1;
cfg.sf.filesLocation = [cfg.location filesep 'filtered_datasets'];
cfg.sf.metric = 'acc'; % (acc = mean ccuracy, auc = are under the curve)

% Frequency limits:
cfg.sf.lfreq = 0;   % Analysis inferior limit (Hz).
cfg.sf.hfreq = 20;  % Analysis superior limit (Hz).

% Filter design:
cfg.sf.ftype = 'bandstop';      % Filter type.
cfg.sf.wtype = 'blackman';      % Window type.
cfg.sf.bw    = 2;               % Filter bandwidth (Hz).
cfg.sf.hbw   = cfg.sf.bw/2;     % Halfband width (Hz).
cfg.sf.order = 2408;            % Filter order.

% Frequency steps:
cfg.sf.fspac = 'log';  % Linear or logarithmic (lin/log.)
cfg.sf.nfreq = 32;     % Number of steps - log (Hz).

%% Enable parallel comp. if the Distrib_Computing_Toolbox is installed:

if license('test','Distrib_Computing_Toolbox')
    cfg.classmodel.parcomp = true;
else
    cfg.classmodel.parcomp = false;
end
