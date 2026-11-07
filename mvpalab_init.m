function [ cfg ] = mvpalab_init(verbose,updatepath)
%% MVPALAB_INIT 
%
%  This function initializes the default configuration structure for
%  MVPAlab. It also adds the toolbox to the MATLAB path, unless updatepath
%  is false, which only returns the default structure.
%
%%  INPUT:
%
%  - {logical} - verbose:
%    Optional. The messages in the command window are printed only when
%    mvpalab_init is called without inputs, so any value hides them.
%
%  - {logical} - updatepath:
%    Optional (true by default). If false, the toolbox is not added to the
%    MATLAB path.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Default configuration structure, with the version of the toolbox in
%    cfg.version (see mvpalab_getversion).

cfg = [];

if nargin < 1
    fprintf('<strong> > Initializing MVPAlab toolbox: </strong>\n');
end

%% UPDATE MATLAB PATH:

if nargin < 2 || updatepath
    loc = which('mvpalab');
    %  Hidden folders (names starting with a dot: .git, .claude, .vscode...)
    %  are excluded, so copies of the toolbox inside them (e.g. git
    %  worktrees) never shadow the functions of this folder.
    addpath(genpath_exclude(loc(1:end-9),{'\..*','demos'}));
end

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
%
% The classifiers build new supertrials in each cross-validation repetition
% (see mvpalab_supertrials and cfg.cv.nreps), so the result depends less on
% one draw of the blocks. With 'seq' all the repetitions use the same
% blocks. RSA builds them once per subject. The feature vectors keep the
% single trials, so they use about cfg.trialaver.ntrials times more memory
% than the supertrials, also on disk in the sliding filter analysis.

%% BALANCED DATASETS:

% cfg.classsize.match      - The classes of a dataset keep the size of the
%                            smallest one.
% cfg.classsize.matchkfold - The size of each class is a multiple of
%                            cfg.cv.nfolds (k-fold only, not used in MVCC).
%
% With supertrials both are applied to the supertrials, which are in random
% order with cfg.trialaver.order = 'rand'. Without them they are applied
% when the data is imported and the first trials of each class are kept.

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
%
% Values 1 and 2 are applied to each trial when the data is imported or,
% with supertrials, to each supertrial (see mvpalab_adjustclasses), so they
% affect all the analyses, including RSA.
% Values 3 and 4 are computed in the training set of each cross-validation
% fold and applied to the test set (mvpalab_fitfold), so they are only
% used by the classifiers (MVPA and MVCC); RSA ignores them. fMRI data
% imported with mvpalab_import_fmri is not normalized.
%
% cfg.normdata = 2 and the power envelope use the whole epoch of each
% trial, so post-stimulus information can reach the baseline. Check the
% pre-stimulus decoding when using them.

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

% cfg.cv.nreps - Number of repeated cross-validations (k-fold). Each
% repetition draws a new random assignment of trials to folds, with new
% supertrials if cfg.trialaver.flag is enabled, and the final result is the
% mean across repetitions. nreps = 1 reproduces the classic single
% cross-validation. Note: running time scales ~linearly with nreps.
% In MVCC with cfg.cv.method = 'none' and supertrials in random order, each
% repetition trains and tests with all the data and only draws new
% supertrials.
% ROC curves are not averaged: they come from the last repetition.

cfg.cv.method  = 'kfold';
cfg.cv.nfolds  = 5;
cfg.cv.nreps   = 1;

%% PERMUTATION TEST

% cfg.stats.tails  =  1 - Above chance clusters (right tail).
% cfg.stats.tails  = -1 - Below chance clusters (left tail).
% cfg.stats.tails  =  2 - Above and below chance (two tails).
%
% With two tails cfg.stats.pgroup is split between them, while the clusters
% above and below chance are two separate tests with their own distribution
% of cluster sizes, each one with the alpha of cfg.stats.pclust. To control
% the error of both tests together use cfg.stats.pclust = 97.5. If only the
% clusters above chance are of interest use cfg.stats.tails = 1.

% cfg.stats.clustcorr - Cluster-level correction (see mvpalab_clusterpvals):
%                       'fdr' - Null distribution of all the cluster sizes
%                               and Benjamini-Hochberg FDR correction of the
%                               cluster p-values (Stelzer et al., 2013).
%                       'max' - Null distribution of the maximum cluster
%                               size of each permutation, family-wise error
%                               rate control (Maris & Oostenveld, 2007).

% cfg.stats.signflip - Group test (see mvpalab_permtest):
%                       false - Permuted maps of each subject (Stelzer et
%                               al., 2013). Valid if permuting the labels
%                               represents the null hypothesis. In MVCC it
%                               can be liberal if datasets A and B contain
%                               effects that are not shared (see
%                               mvpalab_decoding).
%                       true  - Sign flip of each subject around chance
%                               (see mvpalab_signmaps). It does not repeat
%                               the classification, so cfg.stats.nper is not
%                               used. It needs classes of the same size
%                               and enough subjects, needs cfg.stats.clustcorr
%                               = 'max', and only tests accuracy and AUC.
%                               Available for MVPA (not with leave-one-out,
%                               also in the sliding filter), MVCC, RSA,
%                               sliding filter and
%                               the fusion modes 'mean-fmri' and 'mean-eeg'.

cfg.stats.flag   = 0;
cfg.stats.signflip = false;
cfg.stats.nper   = 100;
cfg.stats.nperg  = 1e5;
cfg.stats.pgroup = 95;
cfg.stats.pclust = 95;
cfg.stats.tails  = 2;
cfg.stats.clustcorr = 'fdr';
cfg.stats.shownulldis = 0;

%% REPRESENTATIONAL SIMILARITY ANALYSIS:

% cfg.rsa.modality   - Second-order analysis between the neural RDMs and
%                      the theoretical RDMs (see mvpalab_rsa_time):
%                      'corr'             - Spearman correlation with each
%                                           theoretical model separately.
%                      'regress'          - Linear regression with each
%                                           theoretical model separately
%                                           (one GLM per model).
%                      'multiple_regress' - Multiple linear regression with
%                                           all the theoretical models as
%                                           regressors in the same GLM.
%                      Results: correlation (Fisher z) or beta and t-values
%                      of each model.

% cfg.rsa.distance   - Dissimilarity measure (see mvpalab_computerdm):
%                      'pearson'     - 1 - Pearson correlation
%                                      (cross-validated if nfolds > 1).
%                      'euclidean'   - Squared Euclidean distance
%                                      (cross-validated if nfolds > 1).
%                      'mahalanobis' - Squared Mahalanobis distance with
%                                      multivariate noise normalization
%                                      (crossnobis if nfolds > 1).
%                      'crossnobis'  - Cross-validated squared Mahalanobis
%                                      distance (requires nfolds > 1).
%                      'euclidean', 'mahalanobis' and 'crossnobis' are
%                      always squared and divided by the number of features
%                      (channels or voxels), so nfolds only changes the
%                      noise bias and not the scale of the RDM. Before
%                      version 1.3.0 'euclidean' without cross-validation
%                      was not squared or normalized: the RDM values and
%                      the 'regress' and 'multiple_regress' results change,
%                      the M/EEG 'corr' (Spearman) results do not, and the
%                      fMRI ROI RDMs change slightly (see
%                      mvpalab_computerdm).
% cfg.rsa.nfolds    - Number of folds of the cross-validated RDMs. RSA
%                      has its own number of folds, independent of the
%                      cross-validation of the classifiers (cfg.cv.nfolds).
%                      1 = no cross-validation. Cross-validated RDMs
%                      (nfolds > 1) require condition-wise RDMs
%                      (cfg.rsa.trialwise = false). In fMRI ROI analyses
%                      the folds are always the runs (leave-one-run-out)
%                      and nfolds > 1 only enables the cross-validation.
% cfg.rsa.nreps      - Number of repeated cross-validations of the RDMs
%                      (nfolds > 1). Each repetition draws a new random
%                      assignment of trials to folds and the RDM is the
%                      mean across folds and repetitions. nreps = 1 uses a
%                      single partition. Not used in fMRI ROI analyses
%                      (the runs are a fixed partition). Note: running time
%                      scales ~linearly with nreps.
% cfg.rsa.mnn        - Multivariate noise normalization of the patterns
%                      for the 'pearson' and 'euclidean' distances
%                      (Guggenmos et al., 2018). The patterns are whitened
%                      with the noise covariance estimated from the
%                      residuals of the training trials of each fold (all
%                      the trials if nfolds = 1). With cross-validation,
%                      'euclidean' with mnn is the crossnobis distance.
%                      'mahalanobis' and 'crossnobis' are always noise
%                      normalized, so mnn has no effect on them.
%                      The noise covariance (mnn, 'mahalanobis' and
%                      'crossnobis') needs more trials than conditions; in
%                      fMRI ROI analyses at least 2 runs, or 3 runs with
%                      nfolds > 1 (see mvpalab_noiseprec).
% cfg.rsa.meancenter - Center each pattern across features before computing
%                      the Pearson distance (true = Pearson correlation,
%                      false = cosine similarity).

cfg.rsa.flag = 0;
cfg.rsa.nclass = 0;
cfg.rsa.modality = 'corr';
cfg.rsa.distance = 'pearson';
cfg.rsa.trialwise = true;
cfg.rsa.nfolds = 1;
cfg.rsa.nreps = 1;
cfg.rsa.mnn = false;
cfg.rsa.meancenter = true;

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
cfg.sf.hbw   = cfg.sf.bw/2;     % Halfband width (Hz), set from bw (see mvpalab_genfreqvec).
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

% Decoding with more than two classes: each class is a column of
% cfg.study.dataPaths, cfg.study.dataFiles and cfg.study.conditionIdentifier.
% cfg.classmodel.wvector, .auc and .roc need two classes, and accuracy has a
% chance level of one over the number of classes.

%% SOFTWARE VERSION:

cfg.version = mvpalab_getversion();

%% PCA rank warning disabled. 

warning('off','stats:pca:ColRankDefX');

if nargin < 1
    fprintf('<strong> > MVPAlab is ready! </strong>\n');
end

end

