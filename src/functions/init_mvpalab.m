function [ cfg ] = init_mvpalab(cfg)
%INITIALIZE Summary of this function goes here
%   Detailed explanation goes here
clc;
fprintf('<strong> > Initializing MVPA toolbox: </strong>\n');

%% Define subjects to analyze:
%  Define the subjects that should be analysed in a cell array inside the 
%  cfg data structure:
cfg.subjects = {
    '1.mat';'2.mat';'3.mat';'4.mat';'5.mat';'6.mat';'7.mat';'8.mat';
    '9.mat';'10.mat';'11.mat';'12.mat';'13.mat';'14.mat';'15.mat';'16.mat';
    '17.mat';'18.mat';'19.mat';'20.mat';'21.mat';'22.mat';'23.mat';
    '24.mat';'25.mat';'26.mat';'27.mat';'28.mat';'29.mat';'30.mat';
    '31.mat';'32.mat';
    };

%% Analysis folder:
%  Name of the analysis folder. Data and results will be saved on this
%  folder:
cfg.analysis_name = 'sf_tar_con_vs_tar_inc_0_40Hz_log_8t';
cfg.savedir = ['L:\Matlab\Experiments\EEG_Effort_Choice\data\sf_analysis\' cfg.analysis_name filesep];
create_folder(cfg.savedir);

%% Configuration - Conditions:
cfg.conditions.names = {'tar_con','tar_inc'};
cfg.conditions.dir = 'L:\Matlab\Experiments\EEG_Effort_Choice\data\conditions\mat\';
cfg.conditions.savedir = [cfg.savedir filesep 'conditions' filesep];

%% Configuration - Feature extraction:
%  Configuration of the feature extraction procedure:
cfg.fe.strial.flag     = 1;
cfg.fe.strial.ntrials  = 8;
cfg.fe.matchc.flag     = 1;
cfg.fe.matchc.nfolds   = 5;
cfg.fe.dir             = cfg.conditions.savedir;
cfg.fe.savedir         = [cfg.savedir filesep 'fv'];

%% Configure mvpa analysis:
% .......................... Timming:
cfg.mvpa.tpstart = -1000;
cfg.mvpa.tpend	 = 2000;
cfg.mvpa.tpsteps = 3;
% .......................... Kfold:
cfg.mvpa.nfolds  = 5;
% .......................... Analysis:
cfg.mvpa.tempgen = false;
cfg.mvpa.parcomp = true;
cfg.mvpa.permaps = false;

%% Configure mvcc analysis:
% .......................... Timming:
cfg.mvcc.tpstart = -1000;
cfg.mvcc.tpend	 = 2000;
cfg.mvcc.tpsteps = 3;
% .......................... Kfold:
cfg.mvcc.nfolds  = 5;
% .......................... Analysis:
cfg.mvcc.tempgen = false;
cfg.mvcc.parcomp = true;
cfg.mvcc.permaps = false;

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

