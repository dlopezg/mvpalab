function [permaps,cfg] = mvpalab_permaps(cfg,fv)
%% MVPALAB_PERMAPS
%
%  Deprecated: use [permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted').
%  This function computes the permuted maps of the decoding analysis,
%  whatever the value of cfg.analysis.

if nargin < 2, fv = []; end

warning('mvpalab:deprecated','mvpalab_permaps is deprecated. Use mvpalab_decoding.');

cfg.analysis = 'MVPA';
[permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted');

end
