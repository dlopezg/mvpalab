function mvpalab_checkmethods(cfg)
%% MVPALAB_CHECKMETHODS
%
%  This function checks the methods of a decoding analysis before it
%  starts, so an unsupported value stops with a clear error instead of
%  being ignored:
%
%  - cfg.normdata is 0, 1, 2, 3 or 4.
%  - cfg.cv.method is 'kfold' or 'loo', and also 'none' in MVCC (see
%    mvpalab_ismvcc).
%  - cfg.dimred.method is 'none' or 'pca', and 'pca' needs a whole
%    cfg.dimred.ncomp of at least 1.
%
%  mvpalab_checkdecoding calls it. RSA checks cfg.normdata in
%  mvpalab_checkrsa.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.

if ~ismember(cfg.normdata,0:4)
    error('cfg.normdata must be 0, 1, 2, 3 or 4.');
end

methods = {'kfold','loo'};
kind = 'MVPA';
if mvpalab_ismvcc(cfg), methods{end+1} = 'none'; kind = 'MVCC'; end
if ~any(strcmp(cfg.cv.method,methods))
    error('cfg.cv.method must be %s in %s.',strjoin(methods,', '),kind);
end

if ~any(strcmp(cfg.dimred.method,{'none','pca'}))
    error('cfg.dimred.method must be ''none'' or ''pca''.');
end

ncomp = cfg.dimred.ncomp;
if strcmp(cfg.dimred.method,'pca') && (ncomp < 1 || ncomp ~= round(ncomp))
    error('cfg.dimred.ncomp must be a whole number of at least 1.');
end

end
