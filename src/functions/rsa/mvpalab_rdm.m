function rdm = mvpalab_rdm(cfg,X,Y,folds)
%% MVPALAB_RDM
%
%  This function returns the trial-wise Representational Dissimilarity
%  Matrices for each timepoint.
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
%  - {3D-matrix} - X:
%    Data matrix for an individual subject containing all the trials and
%    conditions. [trials x chanels x timepoints]
%
%  - {1D-categorical} - Y:
%    Categorical vector including data labels
%
%  - {1D-array} - folds (optional):
%    Predefined fold of each trial for the cross-validation.
%
%%  OUTPUT:
%
%  - {3D-matrix} - rdm.matrix:
%    Representational Dissimilarity Matrices for each timepoint:
%    [trials x trials x timepoints]
%    [conditions x conditions x timepoints]

%% Print some information:
fprintf('   - Computing neural RDMs:');

%% Number of timepoints:
ntp = size(X,3);

%% Generate partitions
% If a cross-validated measure is selected, the stratified data partition
% is generated here:

if cfg.rsa.nfolds > 1
    %  Cross-validated RDMs compare the pattern of each condition in the
    %  training set with the pattern of each condition in the test set, so
    %  they are only defined for condition-wise RDMs. In trial-wise RDMs the
    %  training and test trials are different trials.
    if cfg.rsa.trialwise
        error(['Cross-validated RDMs (cfg.rsa.nfolds > 1) require ' ...
            'condition-wise RDMs (cfg.rsa.trialwise = false). Set ' ...
            'cfg.rsa.nfolds = 1 to compute trial-wise RDMs.']);
    end
    %  Every condition needs at least one trial in each fold. Otherwise its
    %  test (or training) pattern is the mean of an empty set (NaN), which
    %  turns its row and column of the RDM into NaN (Euclidean and
    %  crossnobis) or into wrong finite values (cross-validated Pearson).
    conds = unique(Y);
    %  Fold of each trial: predefined or stratified random partition.
    randpart = nargin < 4 || isempty(folds);
    if randpart
        %  The stratified partition only places one trial of a condition in
        %  every fold if the condition has at least cfg.rsa.nfolds trials.
        %  The partition is drawn in each repetition (see below).
        ntrials = arrayfun(@(c) sum(Y == c), conds);
        few = ntrials < cfg.rsa.nfolds;
        if any(few)
            error(['Cross-validated RDMs need at least cfg.rsa.nfolds ' ...
                '= %d trials per condition. Conditions with fewer ' ...
                'trials: %s. Set cfg.rsa.nfolds to at most %d.'], ...
                cfg.rsa.nfolds,strjoin(compose('%s (%d trials)', ...
                string(conds(few)),ntrials(few)),', '),min(ntrials));
        end
        nreps = cfg.rsa.nreps;
    else
        %  Predefined folds (e.g. the runs of an fMRI experiment): at least
        %  two folds, each of them including all the conditions. The
        %  partition is fixed, so it is not repeated.
        folds = folds(:);
        foldids = unique(folds)';
        if numel(foldids) < 2
            error(['Cross-validated RDMs need at least 2 folds (e.g. 2 ' ...
                'runs) and only %d was found.'],numel(foldids));
        end
        for k = 1 : numel(foldids)
            missing = ~ismember(conds,Y(folds == foldids(k)));
            if any(missing)
                error(['Every cross-validation fold must include all ' ...
                    'the conditions. Fold %s has no trials of the ' ...
                    'conditions: %s.'],string(foldids(k)), ...
                    strjoin(string(conds(missing)),', '));
            end
        end
        nreps = 1;
    end
else
    if strcmp(cfg.rsa.distance,'crossnobis')
        error(['The crossnobis distance is cross-validated and requires ' ...
            'cfg.rsa.nfolds > 1. Use cfg.rsa.distance = ''mahalanobis'' ' ...
            'without cross-validation.']);
    end
    randpart = false;
    folds = [];
    foldids = 1;
    nreps = 1;
end

%% Noise normalization:
%  The Mahalanobis and crossnobis distances need the noise precision
%  matrix, estimated from the residuals of the training trials of each
%  fold (all the trials without cross-validation).

noisenorm = any(strcmp(cfg.rsa.distance,{'mahalanobis','crossnobis'}));

if nreps > 1, fprintf(' Repetition: '); end

%% Repeated cross-validation loop:
for rep = 1 : nreps
    %% Stratified random partition for cross-validation:
    %  A new assignment of trials to folds in each repetition.

    if randpart
        strpar = cvpartition(Y,"KFold",cfg.rsa.nfolds);
        folds = zeros(numel(Y),1);
        for k = 1 : cfg.rsa.nfolds
            folds(strpar.test(k)) = k;
        end
        foldids = 1 : cfg.rsa.nfolds;
    end

    %% Iterate over folds
    for k = 1 : numel(foldids)
        %% Split the data in train and test folds:
        %  Fold k is the test set and the trials of the remaining folds are
        %  the training set:

        dataset = mvpalab_datasplit(cfg,X,Y,folds,foldids(k));

        %% Noise precision matrix from the training trials if needed:
        %  Computed before averaging the trials by condition.

        if noisenorm
            prec = mvpalab_noiseprec(dataset.train_x,dataset.train_y);
        else
            prec = [];
        end

        %% Average trials if necessary:
        %  This is used to generate condition-wise RDMs:

        dataset = mvpalab_averagetrials(cfg,dataset);

        train_x = dataset.train_x;
        test_x = dataset.test_x;

        %% Construct RDMs using the specified distance measure:

        if cfg.classmodel.parcomp && ntp > 1
            parfor tp = 1 : ntp
                rdms(:,:,tp,k,rep) = mvpalab_computerdm(cfg,train_x(:,:,tp),test_x(:,:,tp),[],prec);
            end
        else
            for tp = 1 : ntp
                rdms(:,:,tp,k,rep) = mvpalab_computerdm(cfg,train_x(:,:,tp),test_x(:,:,tp),[],prec);
            end
        end
    end

    if nreps > 1, mvpalab_pcounter(rep,nreps); end
end

%% Compute the mean of each fold and repetition:
%  Each fold is used once as test set in each repetition. As in MNE-RSA
%  (compute_rdm_cv), the cross-validated RDM is the average of the RDMs of
%  all the folds, here also averaged across repetitions (all of them have
%  the same number of folds).
if cfg.rsa.nfolds > 1
    rdms = mean(rdms,[4 5]);
end

rdm.rdm = rdms;
rdm.labels = dataset.test_y;

fprintf('- Done.\n\n');

end

