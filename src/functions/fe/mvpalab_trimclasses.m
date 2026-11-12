function data = mvpalab_trimclasses(cfg,data,nfolds)
%% MVPALAB_TRIMCLASSES
%
%  This function trims the number of observations of each class of each
%  dataset, in this order:
%
%  1. cfg.classsize.match: the classes of a dataset keep the size of the
%     smallest one.
%  2. cfg.classsize.matchkfold: the size of each class is a multiple of
%     nfolds, the number of folds of the analysis that calls it, so all
%     the folds have the same size. It gives an error if a class has fewer
%     observations than folds, because the class would be left empty.
%
%  The first observations of each class are kept. Single trials are in the
%  order of the recording, so the last trials are always discarded, while
%  supertrials built in random order discard different trials each time
%  (see mvpalab_supertrials). Without any of these settings the datasets do
%  not change.
%
%  It is applied when the data of each repetition is prepared (see
%  mvpalab_preparedata), not when the data is imported, so each analysis
%  uses its own folds: the decoding passes cfg.cv.nfolds in MVPA with
%  k-fold (1 in MVCC, where the folds of each dataset are drawn on their
%  own, see mvpalab_decodingjob), and RSA passes cfg.rsa.nfolds (see
%  mvpalab_rsa_time).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.classsize).
%
%  - {struct} - data:
%    Data (X) and labels (Y) of dataset A (data.a) and, in MVCC, of
%    dataset B (data.b). X: [observations x channels x timepoints].
%
%  - {int} - nfolds:
%    Number of folds of cfg.classsize.matchkfold (1 if the class sizes do
%    not depend on the folds).
%
%%  OUTPUT:
%
%  - {struct} - data:
%    The same structure with the trimmed classes.

matchkfold = cfg.classsize.matchkfold && nfolds > 1;
if ~cfg.classsize.match && ~matchkfold, return; end

sets = fieldnames(data);
for dataset = 1 : numel(sets)
    [fv,classes] = mvpalab_splitclasses(data.(sets{dataset}));
    nobs = cellfun(@(x) size(x,1),fv);

    if cfg.classsize.match
        nobs(:) = min(nobs);
    end

    if matchkfold
        if any(nobs < nfolds)
            error('mvpalab:trimclasses',...
                ['Class %s has fewer observations than the %d folds of ' ...
                'cfg.classsize.matchkfold.'],classes{find(nobs < nfolds,1)},nfolds);
        end
        nobs = floor(nobs/nfolds)*nfolds;
    end

    for condition = 1 : numel(fv)
        fv{condition} = fv{condition}(1:nobs(condition),:,:);
    end
    data.(sets{dataset}) = mvpalab_joinclasses(fv,classes);
end

end
