function [res,cfg] = mvpalab_mvcc(cfg,fv)
%% MVPALAB_MVCC
%
%  Deprecated: use [result,cfg] = mvpalab_decoding(cfg,fv).
%  This function computes the cross-classification analysis.

if nargin < 2, fv = []; end

warning('mvpalab:deprecated',...
    'mvpalab_mvcc is deprecated. Use mvpalab_decoding.');

if ~mvpalab_ismvcc(cfg)
    error('mvpalab:mvcc',...
        'mvpalab_mvcc needs the files of dataset B (see mvpalab_ismvcc).');
end
[res,cfg] = mvpalab_decoding(cfg,fv);

end
