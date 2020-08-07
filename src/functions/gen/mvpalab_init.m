function [ cfg ] = mvpalab_init(cfg)
%INITIALIZE Summary of this function goes here
%   Detailed explanation goes here
clear
clc
cfg = [];

fprintf('<strong> > Initializing MVPAlab toolbox: </strong>\n');

%% Datafiles and paths:
cfg.study.dataPaths = {{},{};{},{}};
cfg.study.dataFiles = {{},{};{},{}};

%% Configuration - Feature extraction:

% Supertrial generation:
cfg.fext.strial.flag     = false;
cfg.fext.strial.ntrials  = 0;

% Match class size:
cfg.fext.matchcsize = false;
cfg.fext.matchkfold = false;

%% Configuration - Feature selection:

% Feature selection methods:
% 'pca' - Principal Component Analysis
% 'pls' - Partial Least Squares
% 'lda' - Linear Discriminant Analysis (in progress)

cfg.fsel.method = 'pca';
cfg.fsel.flag   = false;
cfg.fsel.ncomp  = 3;

%% Configuration - Data normalization:

% Notmalization methods:
% 0 - raw data
% 1 - z-score (across features)
% 2 - z-score (across time)
% 3 - z-score (across trials)
% 4 - std_nor (across trials)

cfg.normdata = 0; 

%% Configuration - Data smoothing:

% Notmalization methods:
% 0 - raw data
% 1 - z-score (across features)
% 2 - z-score (across time)
% 3 - z-score (across trials)
% 4 - std_nor (across trials)

cfg.smoothdata.flag     = false;
cfg.smoothdata.method   = 'movmean';
cfg.smoothdata.window   = 10;

%% Configuration - Analysis timming:

cfg.tm.tpstart   = -200;
cfg.tm.tpend     = 1500;
cfg.tm.tpsteps   = 3;

%% Configuration - Classification procedure:

% Classification algorithms:
% 'svm' - Support Vector Machine.
% 'lda' - Linear Discriminant Analysis.

cfg.classmodel.method = 'svm';
cfg.classmodel.kernel = 'lineal';

% Analysis configuration:
cfg.classmodel.tempgen = 0;
cfg.classmodel.parcomp = 1;
cfg.classmodel.permlab = 0;
cfg.classmodel.roc     = 0;
cfg.classmodel.confmat = 0;
cfg.classmodel.wvector = 0;
    

% Optimization configuration:
cfg.classmodel.optimize.flag = false;
cfg.classmodel.optimize.params = {'BoxConstraint'};
cfg.classmodel.optimize.opt = struct('Optimizer','gridsearch',...
    'ShowPlots',false,...
    'Verbose',0,...
    'Kfold', 5);

%% Configuration - Cross-validation procedure:

% Classification algorithms:
% 'kfold' - K-Fold cross-validation.
% 'loo'   - Leave-one-out cross-validation.

cfg.cv.method  = 'kfold';
cfg.cv.nfolds  = 5;

%% Configuration - Statistic for permutation method:

cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e5;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;

%% Configure sliding filter analysis:
% Flag:
cfg.sf.flag = 0;

% Frequency limits:
cfg.sf.lfreq = 0;              % Analysis inferior limit (Hz).
cfg.sf.hfreq = 40;             % Analysis superior limit (Hz).

% Filter design:
cfg.sf.ftype = 'bandstop';      % Filter type.
cfg.sf.wtype = 'blackman';      % Window type.
cfg.sf.bw    = 2;               % Filter bandwidth (Hz).
cfg.sf.hbw   = cfg.sf.bw/2;     % Halfband width (Hz).
cfg.sf.order = 1408;            % Filter order.

% Frequency steps:
cfg.sf.logsp = true;            % Log-spaced frequency steps.
cfg.sf.linsp = ~cfg.sf.logsp;   % Lin-spaced frequency steps.
cfg.sf.fstep = 1;               % Frequency steps - lin (Hz).
cfg.sf.nfreq = 40;              % Number of steps - log (Hz).

% For data import (mvpalab_load):
if ~cfg.sf.flag; cfg.sf.nfreq = 1; end


%% Other configuration - Parallel computing:
fprintf('<strong> > Checking parallel computing: </strong>');
% if license('test','Distrib_Computing_Toolbox')
%     fprintf('- Toolbox installed.\n');
%     cfg.classmodel.parcomp = true;
%     p = gcp('nocreate'); 
%     if isempty(p)
%         parpool;
%     end
% else
%     disp('- Toolbox not available');
%     cfg.classmodel.parcomp = false;
% end

fprintf('<strong> > MVPAlab is ready! </strong>\n');

%% PCA rank warning disabled. 
warning('off','stats:pca:ColRankDefX');

%% Software version:
cfg.version = 'BETA v0.1';

end

