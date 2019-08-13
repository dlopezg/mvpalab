function [ cfg ] = initialize(cfg)
%INITIALIZE Summary of this function goes here
%   Detailed explanation goes here
clc;
fprintf('<strong> > Initializing MVPA toolbox: </strong>\n');

%% Configuration - Feature extraction:
cfg.fe.strial.flag     = 1;
cfg.fe.strial.ntrials  = 8;
cfg.fe.matchc.flag     = 1;
cfg.fe.matchc.nfolds   = 5;

%% Configure mvpa analysis:
% .......................... Timming:
cfg.mvpa.tpstart = -200;
cfg.mvpa.tpend	 = 2000;
cfg.mvpa.tpsteps = 3;
% .......................... Kfold:
cfg.mvpa.nfolds  = 5;
% .......................... Analysis:
cfg.mvpa.tempgen = false;
cfg.mvpa.parcomp = false;
cfg.mvpa.permaps = true;

%% Configure mvcc analysis:
% .......................... Timming:
cfg.mvcc.tpstart = -200;
cfg.mvcc.tpend	 = 2000;
cfg.mvcc.tpsteps = 3;
% .......................... Kfold:
cfg.mvcc.nfolds  = 5;
% .......................... Analysis:
cfg.mvcc.tempgen = false;
cfg.mvcc.parcomp = false;
cfg.mvcc.permaps = true;


%% Statistic for Stelzer method:
cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e6;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;

%% Plots:
cfg.plots.stats = false;

%% Other configuration - Parallel computing:
fprintf('<strong> > Checking parallel computing: </strong>');
if license('test','Distrib_Computing_Toolbox')
    fprintf('- Toolbox installed.\n');
    cfg.mvpa.parcomp = true;
    p = gcp('nocreate'); 
    if isempty(p)
        parpool;
    end
else
    disp('- Toolbox not available');
    cfg.mvpa.parcomp = false;
end
clc
fprintf('<strong> > MVPATOOLBOX is ready! </strong>\n');
end

