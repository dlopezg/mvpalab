function [ cfg ] = init_mvpalab(cfg)
%INITIALIZE Summary of this function goes here
%   Detailed explanation goes here
clc;
fprintf('<strong> > Initializing MVPA toolbox: </strong>\n');

%% Configuration - Feature extraction:
%  Configuration of the feature extraction procedure:
cfg.fe.strial.flag     = 1;
cfg.fe.strial.ntrials  = 8;
cfg.fe.matchc.flag     = 1;
cfg.fe.matchc.nfolds   = 5;
cfg.fe.dir             = cfg.conditions.savedir;
cfg.fe.savedir         = [cfg.savedir filesep 'fv'];

%% Configuration - Feature selection:
%  Configuration of the feature selection method:
% .......................... PCA:
cfg.fs.pca.flag = false;
cfg.fs.pca.ncom = 5;
% .......................... PLS:
cfg.fs.pls.flag = false;
cfg.fs.pls.ncom = 5;

%% Configure mvpa analysis:
% .......................... Timming:
cfg.analysis.tpstart = -200;
cfg.analysis.tpend	 = 1500;
cfg.analysis.tpsteps = 3;
% .......................... Kfold:
cfg.analysis.nfolds  = 5;
% .......................... Analysis:
cfg.analysis.tempgen = false;
cfg.analysis.parcomp = true;

%% Configure sliding filter analysis:
% .......................... Frequency limits:
cfg.sf.lfreq = 0;              % Analysis inferior limit (Hz).
cfg.sf.hfreq = 40;             % Analysis superior limit (Hz)
% .......................... Filter design:
cfg.sf.ftype = 'bandstop';      % Filter type.
cfg.sf.wtype = 'blackman';      % Window type.
cfg.sf.bw    = 2;               % Filter bandwidth (Hz).
cfg.sf.hbw   = cfg.sf.bw/2;     % Halfband width (Hz).
cfg.sf.order = 1408;            % Filter order.
% .......................... Frequency steps:
cfg.sf.logsp = true;            % Log-spaced frequency steps.
cfg.sf.linsp = ~cfg.sf.logsp;   % Lin-spaced frequency steps.
cfg.sf.fstep = 1;               % Frequency steps - lin (Hz).
cfg.sf.nfreq = 40;              % Number of steps - log (Hz).
% .......................... Other:
cfg.sf.dir = cfg.fe.savedir;
cfg.sf.stats.nper = 10;

%% Statistic for Stelzer method:
cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e6;
cfg.stats.pgroup = 99.9;
cfg.stats.pclust = 99.9;

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

