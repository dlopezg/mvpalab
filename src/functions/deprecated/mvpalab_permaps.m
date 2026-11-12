function [permaps,cfg] = mvpalab_permaps(cfg,fv)
%% MVPALAB_PERMAPS
%
%  Deprecated: use [permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted').
%  This function computes the permuted maps of the decoding analysis.

if nargin < 2, fv = []; end

warning('mvpalab:deprecated',...
    'mvpalab_permaps is deprecated. Use mvpalab_decoding.');

if mvpalab_ismvcc(cfg)
    error('mvpalab:permaps',...
        'mvpalab_permaps needs a study without dataset B (see mvpalab_ismvcc).');
end
[permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted');

end
