function mvpalab_checkmethods(cfg)
%% MVPALAB_CHECKMETHODS
%
%  This function checks the methods of a decoding analysis before it
%  starts, so an unsupported value stops with a clear error instead of
%  being ignored:
%
%  - cfg.normdata is one of 0, 1, 2, 3 or 4.
%  - cfg.cv.method is 'kfold' or 'loo', and also 'none' in MVCC (see
%    mvpalab_ismvcc).
%  - cfg.cv.nreps is a whole number of at least 1, and with k-fold
%    cfg.cv.nfolds is a whole number of at least 2 (leave-one-out has one
%    fold per trial and 'none' has one fold, so they do not use it).
%  - cfg.dimred.method is 'none' or 'pca', and 'pca' needs a whole
%    cfg.dimred.ncomp of at least 1, a single number.
%
%  mvpalab_checkdecoding calls it. RSA checks cfg.normdata in
%  mvpalab_checkrsa.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.

if ~isscalar(cfg.normdata) || ~ismember(cfg.normdata,0:4)
    error('cfg.normdata must be 0, 1, 2, 3 or 4.');
end

methods = {'kfold','loo'};
kind = 'MVPA';
if mvpalab_ismvcc(cfg), methods{end+1} = 'none'; kind = 'MVCC'; end
if ~any(strcmp(cfg.cv.method,methods))
    error('cfg.cv.method must be %s in %s.',strjoin(methods,', '),kind);
end

nreps = cfg.cv.nreps;
if ~isscalar(nreps) || nreps < 1 || nreps ~= round(nreps)
    error('cfg.cv.nreps must be a whole number of at least 1.');
end

nfolds = cfg.cv.nfolds;
if strcmp(cfg.cv.method,'kfold') && ...
        (~isscalar(nfolds) || nfolds < 2 || nfolds ~= round(nfolds))
    error('cfg.cv.nfolds must be a whole number of at least 2 with k-fold.');
end

if ~any(strcmp(cfg.dimred.method,{'none','pca'}))
    error('cfg.dimred.method must be ''none'' or ''pca''.');
end

ncomp = cfg.dimred.ncomp;
if strcmp(cfg.dimred.method,'pca') && ...
        (~isscalar(ncomp) || ncomp < 1 || ncomp ~= round(ncomp))
    error('cfg.dimred.ncomp must be a whole number of at least 1.');
end

end
