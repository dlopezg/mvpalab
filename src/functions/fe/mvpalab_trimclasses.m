function fv = mvpalab_trimclasses(cfg,fv)
%% MVPALAB_TRIMCLASSES
%
%  This function trims the number of observations of each class, in this
%  order:
%
%  1. cfg.classsize.match: the classes of a dataset keep the size of the
%     smallest one.
%  2. cfg.classsize.matchkfold: the size of each class is a multiple of
%     the number of folds, so all the folds have the same size: those of
%     the classifiers (cfg.cv.nfolds) in MVPA with k-fold, and those of the
%     RDMs (cfg.rsa.nfolds, if larger than 1) in RSA, which is any analysis
%     other than MVPA and MVCC (see mvpalab_checkmethods). It is not used
%     in MVCC, where the folds of each dataset are drawn on their own (see
%     mvpalab_dirpartition). It gives an error if a class has fewer
%     observations than folds, because the class would be left empty.
%
%  The first observations of each class are kept. Single trials are in the
%  order of the recording, so the last trials are always discarded, while
%  supertrials built in random order discard different trials each time
%  (see mvpalab_supertrials).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - fv:
%    Data matrix of each class [observations x channels x timepoints]. One
%    row per dataset and one column per class.
%
%%  OUTPUT:
%
%  - {cell array} - fv:
%    The same cell array with the trimmed data matrices.

for dataset = 1 : size(fv,1)
    nobs = cellfun(@(x) size(x,1),fv(dataset,:));

    if cfg.classsize.match
        nobs(:) = min(nobs);
    end

    if cfg.classsize.matchkfold
        nfolds = foldsof(cfg);
        if any(nobs < nfolds)
            error(['Class %d has fewer observations than the %d folds of ' ...
                'cfg.classsize.matchkfold.'],find(nobs < nfolds,1),nfolds);
        end
        nobs = floor(nobs/nfolds)*nfolds;
    end

    for condition = 1 : size(fv,2)
        fv{dataset,condition} = fv{dataset,condition}(1:nobs(condition),:,:);
    end
end

end

function nfolds = foldsof(cfg)
%% Number of folds of the analysis, 1 if the class sizes do not depend on
%  them.

nfolds = 1;
if strcmp(cfg.analysis,'MVPA') && strcmp(cfg.cv.method,'kfold')
    nfolds = cfg.cv.nfolds;
elseif ~any(strcmp(cfg.analysis,{'MVPA','MVCC'})) && cfg.rsa.nfolds > 1
    nfolds = cfg.rsa.nfolds;
end

end
