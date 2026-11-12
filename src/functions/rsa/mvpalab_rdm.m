function rdm = mvpalab_rdm(cfg,X,Y,folds)
%% MVPALAB_RDM
%
%  This function returns the Representational Dissimilarity Matrices of
%  one subject at each timepoint, between the trials or, if
%  cfg.rsa.trialwise is false, between the conditions (see
%  mvpalab_averagetrials).
%
%  Cross-validation (cfg.rsa.nfolds > 1): each fold is used once as test
%  set and the remaining folds as training set. By default the folds are a
%  stratified random partition of the trials into cfg.rsa.nfolds folds.
%  Predefined folds can be provided instead (e.g. the runs of an fMRI
%  experiment, leave-one-run-out), and then the number of folds is the
%  number of different values in folds.
%
%  Repeated cross-validation (cfg.rsa.nreps > 1): the stratified random
%  partition is drawn cfg.rsa.nreps times and the cross-validated RDM is the
%  mean across folds and repetitions, as cfg.cv.nreps for the classifiers.
%  This reduces the variance due to the particular assignment of trials to
%  folds. With predefined folds the partition is fixed and nreps is not
%  used.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {matrix} - X:
%    Data of the subject [trials x channels x timepoints].
%
%  - {categorical} - Y:
%    Condition of each trial [trials x 1].
%
%  - {matrix} - folds (optional):
%    Predefined fold of each trial for the cross-validation.
%
%%  OUTPUT:
%
%  - {struct} - rdm:
%    - rdm:    Representational Dissimilarity Matrices
%              [trials x trials x timepoints] or
%              [conditions x conditions x timepoints].
%    - labels: Condition of each row of the RDMs: the label of each
%              trial, or the conditions 1 to conditions, in the order of
%              unique(Y), for condition-wise RDMs.

%% Print some information:
fprintf('   - Computing neural RDMs:');

%% Checks and folds of each repetition:
if nargin < 4, folds = []; end
mvpalab_validaterdm(cfg,Y,folds);
folds = mvpalab_rdmfolds(cfg,Y,folds);
nreps = size(folds,2);

ntp = size(X,3);
nworkers = 0;
if cfg.classmodel.parcomp && ntp > 1, nworkers = Inf; end

%% Noise normalization:
%  The Mahalanobis and crossnobis distances need the noise precision
%  matrix, estimated from the residuals of the training trials of each
%  fold (all the trials without cross-validation).

noisenorm = any(strcmp(cfg.rsa.distance,{'mahalanobis','crossnobis'}));

%% Multivariate noise normalization of the patterns (cfg.rsa.mnn):
%  The Pearson and Euclidean distances are computed between whitened
%  patterns (x * W, W = sigma^(-1/2), see mvpalab_whitening), with the
%  noise covariance estimated from the training trials of each fold, as in
%  Guggenmos et al. (2018). The Mahalanobis and crossnobis distances
%  already include the noise normalization, so they are not whitened again.

mnn = cfg.rsa.mnn && ~noisenorm;

if nreps > 1, fprintf(' Repetition: '); end

%% Repeated cross-validation loop:
for rep = 1 : nreps
    %% Folds of this repetition (see mvpalab_rdmfolds):
    foldsrep = folds(:,rep);
    foldids = unique(foldsrep)';

    %% Iterate over folds
    %  rdms - [conditions x conditions x timepoints x folds] of this
    %  repetition.
    rdms = [];
    for k = 1 : numel(foldids)
        %% Split the data in train and test folds:
        %  Fold k is the test set and the trials of the remaining folds are
        %  the training set:

        dataset = mvpalab_datasplit(cfg,X,Y,foldsrep,foldids(k));

        %% Noise precision or whitening matrix from the training trials:
        %  Computed before averaging the trials by condition, if needed.

        prec = [];
        if noisenorm
            prec = mvpalab_noiseprec(dataset.train_x,dataset.train_y);
        elseif mnn
            [~,sigma] = mvpalab_noiseprec(dataset.train_x,dataset.train_y);
            W = mvpalab_whitening(sigma);
        end

        %% Average trials if necessary:
        %  This is used to generate condition-wise RDMs:

        dataset = mvpalab_averagetrials(cfg,dataset);

        train_x = dataset.train_x;
        test_x = dataset.test_x;

        %% Whiten the training and test patterns if needed:
        %  The same matrix for all the timepoints (x * W at each timepoint).
        %  Averaging is linear, so whitening the condition means is the
        %  same as averaging the whitened trials.

        if mnn
            train_x = pagemtimes(train_x,W);
            test_x = pagemtimes(test_x,W);
        end

        %% Construct RDMs using the specified distance measure:

        parfor (tp = 1 : ntp, nworkers)
            rdms(:,:,tp,k) = mvpalab_computerdm(cfg,train_x(:,:,tp),test_x(:,:,tp),prec);
        end
    end

    %% Compute the mean of each fold:
    %  Each fold is used once as test set. As in MNE-RSA (compute_rdm_cv),
    %  the cross-validated RDM is the average of the RDMs of all the folds.
    rdms = mean(rdms,4);

    %% Accumulate the RDMs across repetitions:
    %  Only the sum is kept, so the memory does not grow with nreps.
    if rep == 1
        rdmsum = rdms;
    else
        rdmsum = rdmsum + rdms;
    end

    if nreps > 1, mvpalab_pcounter(rep,nreps); end
end

%% Mean across repetitions:
%  All the repetitions have the same number of folds, so this is the mean
%  across folds and repetitions.

rdm.rdm = rdmsum / nreps;
rdm.labels = dataset.test_y;

fprintf('- Done.\n\n');

end

