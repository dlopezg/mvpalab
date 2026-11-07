function fv = mvpalab_adjustclasses(cfg,fv)
%% MVPALAB_ADJUSTCLASSES
%
%  This function adjusts the observations of each class, in this order:
%
%  1. cfg.classsize.match: the classes of a dataset keep the size of the
%     smallest one.
%  2. cfg.classsize.matchkfold: the size of each class is a multiple of
%     cfg.cv.nfolds (k-fold only, and not in MVCC, where the folds of each
%     dataset are drawn on their own, see mvpalab_dirpartition).
%  3. cfg.normdata = 1 or 2: each observation is z-scored across features
%     or across time.
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
%    The same cell array with the adjusted data matrices.

for ctxt = 1 : size(fv,1)
    nobs = cellfun(@(class) size(class,1),fv(ctxt,:));

    if cfg.classsize.match
        nobs(:) = min(nobs);
    end

    if cfg.classsize.matchkfold && strcmp(cfg.cv.method,'kfold') && size(fv,1) == 1
        nobs = floor(nobs/cfg.cv.nfolds)*cfg.cv.nfolds;
    end

    for class = 1 : size(fv,2)
        fv{ctxt,class} = fv{ctxt,class}(1:nobs(class),:,:);
        fv{ctxt,class} = trialnorm(cfg,fv{ctxt,class});
    end
end

end

function X = trialnorm(cfg,X)
%% Z-score of each observation across features (cfg.normdata = 1) or across
%  time (cfg.normdata = 2). The other values are applied in each fold (see
%  mvpalab_fitfold).

switch cfg.normdata
    case 1
        X = zscore(X,[],2);
    case 2
        X = zscore(X,[],3);
end

end
