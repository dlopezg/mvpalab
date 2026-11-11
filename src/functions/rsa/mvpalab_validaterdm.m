function mvpalab_validaterdm(cfg,Y,folds)
%% MVPALAB_VALIDATERDM
%
%  This function checks the data of the RDMs of one subject before they
%  are computed (see mvpalab_rdm). The settings that do not depend on the
%  data are checked before the analysis starts (see mvpalab_validatersa).
%  With cross-validated RDMs (cfg.rsa.nfolds > 1):
%
%  - Every condition needs at least one trial in each fold. Otherwise its
%    pattern is the mean of an empty set (NaN), which turns its row and
%    column of the RDM into NaN (Euclidean and crossnobis) or into wrong
%    finite values (cross-validated Pearson). A stratified partition only
%    places one trial of a condition in every fold if the condition has at
%    least cfg.rsa.nfolds trials, and predefined folds must include all
%    the conditions.
%  - Predefined folds need at least two folds.
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

if cfg.rsa.nfolds <= 1, return; end

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
