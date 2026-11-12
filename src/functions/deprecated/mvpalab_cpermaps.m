function [permaps,cfg] = mvpalab_cpermaps(cfg,fv)
%% MVPALAB_CPERMAPS
%
%  Deprecated: use [permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted').
%  This function computes the permuted maps of the cross-classification
%  analysis.

if nargin < 2, fv = []; end

warning('mvpalab:deprecated',...
    'mvpalab_cpermaps is deprecated. Use mvpalab_decoding.');

if ~mvpalab_ismvcc(cfg)
    error('mvpalab:cpermaps',...
        'mvpalab_cpermaps needs the files of dataset B (see mvpalab_ismvcc).');
end
[permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted');

end
