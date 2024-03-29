function [ cfg ] = mvpalab_init(verbose)
%% MVPALAB_INIT 
%
%  This function initializes the default configuration structure for
%  MVPAlab.

cfg = [];

if nargin < 1
    fprintf('<strong> > Initializing MVPAlab toolbox: </strong>\n');
end

%% UPDATE MATLAB PATH:

loc = which('mvpalab');
addpath(genpath_exclude(loc(1:end-9),{'\.git','demos'}));

%% ANALYSIS TYPE:

cfg.analysis = 'MVPA';

% cfg.analysis = 'MVPA' - Multivariate Pattern Analysis.
% cfg.analysis = 'MVCC' - Multivariate Cross-Classification.

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

cfg.classsize.match = false;
cfg.classsize.matchkfold = false;

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

% cfg.smoothdata.method = 'none'     - Data smooth disabled.
% cfg.smoothdata.method = 'moving'   - Moving average method.
% cfg.smoothdata.method = 'gaussian' - Gaussian kernel.

cfg.smoothdata.method   = 'none';
cfg.smoothdata.window   = 1;

%% ANALYSIS TIMING:

cfg.tm.tpstart   = 0;
cfg.tm.tpend     = 0;
cfg.tm.tpstart_  = 0;
cfg.tm.tpend_    = 0;
cfg.tm.tpsteps   = 1;

%% ELECTRODE SELECTION:
cfg.channels.selected = [];
cfg.channels.chanloc = [];
cfg.channels.selectedchanloc = [];

%% CLASSIFICATION ALGORITHM:

% cfg.classmodel.method = 'svm' - Support Vector Machine.
% cfg.classmodel.method = 'da'  - Discriminant Analysis.

% cfg.classmodel.kernel = 'linear'     - Support Vector Machine.
% cfg.classmodel.kernel = 'gaussian'   - Support Vector Machine.
% cfg.classmodel.kernel = 'rbf'        - Support Vector Machine.
% cfg.classmodel.kernel = 'polynomial' - Support Vector Machine.

% cfg.classmodel.kernel = 'linear'     - Discriminant Analysis.
% cfg.classmodel.kernel = 'quadratic'  - Discriminant Analysis.

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
cfg.classmodel.permlab = false;

% Enable parallel computation by default if the Distrib_Computing_Toolbox 
% is installed: 
if license('test','Distrib_Computing_Toolbox')
    cfg.classmodel.parcomp = true;
else
    cfg.classmodel.parcomp = false;
end

%% CROSS-VALIDATIONN PROCEDURE:

% cfg.cv.method = 'kfold' - K-Fold cross-validation.
% cfg.cv.method = 'loo'   - Leave-one-out cross-validation.

cfg.cv.method  = 'kfold';
cfg.cv.nfolds  = 5;
cfg.cv.loo     = [];

%% PERMUTATION TEST

% cfg.stats.type   = 'above';  - Above chance clusters (Rigth tail)
% cfg.stats.type   = 'below';  - Below chance clusters (Rigth tail)
% cfg.stats.type   = 'both';   - Above and below chance (Two tails)

cfg.stats.flag   = 0;
cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e5;
cfg.stats.pgroup = 95;
cfg.stats.pclust = 95;
cfg.stats.tails  = 2;
cfg.stats.shownulldis = 0;

%% REPRESENTATIONAL SIMILARITY ANALYSIS:

% cfg.rsa.analysis   = 'regress';   - Fit GLM using theoRDMs as regressors. 
% cfg.rsa.analysis   = 'corr';      - Correlate theoRDMs with neural RDMs.

cfg.rsa.flag = 0;
cfg.rsa.nclass = 0;
cfg.rsa.modality = 'corr'; 
cfg.rsa.distance = 'pearson';
cfg.rsa.trialwise = true;
cfg.rsa.normrdm = true;

%% SLIDING FILTER ANALYSIS CONFIGURATION:

% Flag:
cfg.sf.flag = 0;
cfg.sf.filesLocation = '';
cfg.sf.savefdata = false;
cfg.sf.metric = 'acc';

% Frequency limits:
cfg.sf.lfreq = 0;   % Analysis inferior limit (Hz).
cfg.sf.hfreq = 40;  % Analysis superior limit (Hz).

% Filter design:
cfg.sf.ftype = 'bandstop';      % Filter type.
cfg.sf.wtype = 'blackman';      % Window type.
cfg.sf.bw    = 2;               % Filter bandwidth (Hz).
cfg.sf.hbw   = cfg.sf.bw/2;     % Halfband width (Hz).
cfg.sf.order = 1408;            % Filter order.

% Frequency steps:
cfg.sf.fspac = 'log';  % Linear or logarithmic (lin/log.)
cfg.sf.nfreq = 1;      % Number of steps - log (Hz).

%% DATAFILES, PATHS AND CONDITIONN :

cfg.study.dataPaths = {{},{};{},{}};
cfg.study.dataFiles = {{},{};{},{}};

cfg.study.conditionIdentifier = {
    'condition_a','condition_b'; % Context 1
    'condition_c','condition_d'  % Context 2
    };

%% SOFTWARE VERSION:

cfg.version = mvpalab_getversion();

%% PCA rank warning disabled. 

warning('off','stats:pca:ColRankDefX');

if nargin < 1
    fprintf('<strong> > MVPAlab is ready! </strong>\n');
end

end

