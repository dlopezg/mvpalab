function [permaps,cfg] = mvpalab_cpermaps(cfg,fv)
%% MVPALAB_CPERMAPS
%
%  Deprecated: use [permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted').
%  This function computes the permuted maps of the cross-classification
%  analysis, whatever the value of cfg.analysis.

if nargin < 2, fv = []; end

warning('mvpalab:deprecated','mvpalab_cpermaps is deprecated. Use mvpalab_decoding.');

cfg.analysis = 'MVCC';
[permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted');

end
