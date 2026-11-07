function mvpalab_checkrdm(cfg,Y,folds)
%% MVPALAB_CHECKRDM
%
%  This function checks the settings of the RDMs of one subject before
%  they are computed (see mvpalab_rdm):
%
%  - Cross-validated RDMs (cfg.rsa.nfolds > 1) compare the pattern of each
%    condition in the training set with the pattern of each condition in
%    the test set, so they need condition-wise RDMs: in trial-wise RDMs the
%    training and test trials are different trials.
%  - Every condition needs at least one trial in each fold. Otherwise its
%    pattern is the mean of an empty set (NaN), which turns its row and
%    column of the RDM into NaN (Euclidean and crossnobis) or into wrong
%    finite values (cross-validated Pearson). A stratified partition only
%    places one trial of a condition in every fold if the condition has at
%    least cfg.rsa.nfolds trials, and predefined folds must include all
%    the conditions.
%  - Predefined folds need at least two folds, and cfg.rsa.nreps must be a
%    positive integer.
%  - The crossnobis distance is cross-validated, so it needs
%    cfg.rsa.nfolds > 1.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.rsa).
%
%  - {1D-array} - Y:
%    Condition of each trial.
%
%  - {1D-array} - folds:
%    Predefined fold of each trial, or empty for a stratified partition.

if cfg.rsa.nfolds <= 1
    if strcmp(cfg.rsa.distance,'crossnobis')
        error(['The crossnobis distance is cross-validated and requires ' ...
            'cfg.rsa.nfolds > 1. Use cfg.rsa.distance = ''mahalanobis'' ' ...
            'without cross-validation.']);
    end
    return
end

if cfg.rsa.trialwise
    error(['Cross-validated RDMs (cfg.rsa.nfolds > 1) require ' ...
        'condition-wise RDMs (cfg.rsa.trialwise = false). Set ' ...
        'cfg.rsa.nfolds = 1 to compute trial-wise RDMs.']);
end

conds = unique(Y);

if isempty(folds)
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
    if ~(isscalar(nreps) && nreps >= 1 && nreps == round(nreps))
        error(['cfg.rsa.nreps must be a positive integer (number of ' ...
            'repeated cross-validations).']);
    end
    return
end

foldids = unique(folds(:))';
if numel(foldids) < 2
    error(['Cross-validated RDMs need at least 2 folds (e.g. 2 ' ...
        'runs) and only %d was found.'],numel(foldids));
end
for k = 1 : numel(foldids)
    missing = ~ismember(conds,Y(folds(:) == foldids(k)));
    if any(missing)
        error(['Every cross-validation fold must include all ' ...
            'the conditions. Fold %s has no trials of the ' ...
            'conditions: %s.'],string(foldids(k)), ...
            strjoin(string(conds(missing)),', '));
    end
end

end
