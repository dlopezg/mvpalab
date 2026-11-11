function [res,cfg] = mvpalab_mvpa(cfg,fv)
%% MVPALAB_MVPA
%
%  Deprecated: use [result,cfg] = mvpalab_decoding(cfg,fv).
%  This function computes the time-resolved or temporal generalization
%  decoding analysis.

if nargin < 2, fv = []; end

warning('mvpalab:deprecated','mvpalab_mvpa is deprecated. Use mvpalab_decoding.');

if mvpalab_ismvcc(cfg)
    error('mvpalab_mvpa needs a study without dataset B (see mvpalab_ismvcc).');
end
[res,cfg] = mvpalab_decoding(cfg,fv);

end
