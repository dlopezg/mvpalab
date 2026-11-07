function folds = mvpalab_rdmfolds(cfg,Y,folds)
%% MVPALAB_RDMFOLDS
%
%  This function returns the fold of each trial in each repetition of the
%  cross-validation of the RDMs (see mvpalab_rdm):
%
%  - Stratified partition (no predefined folds): a new assignment of the
%    trials to cfg.rsa.nfolds folds in each of the cfg.rsa.nreps
%    repetitions.
%  - Predefined folds (e.g. the runs of an fMRI experiment): the partition
%    is fixed, so it is not repeated.
%  - Without cross-validation (cfg.rsa.nfolds = 1): one fold with all the
%    trials.
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
%    Predefined fold of each trial, or empty.
%
%%  OUTPUT:
%
%  - {matrix} - folds:
%    Fold of each trial in each repetition [trials x repetitions].

if cfg.rsa.nfolds <= 1
    folds = ones(numel(Y),1);
elseif ~isempty(folds)
    folds = folds(:);
else
    folds = zeros(numel(Y),cfg.rsa.nreps);
    for rep = 1 : cfg.rsa.nreps
        strpar = cvpartition(Y,"KFold",cfg.rsa.nfolds);
        for k = 1 : cfg.rsa.nfolds
            folds(strpar.test(k),rep) = k;
        end
    end
end

end
