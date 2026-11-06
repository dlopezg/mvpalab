function [res,cfg] = mvpalab_mvcc(cfg,fv)
%% MVPALAB_MVCC
%
%  Deprecated: use [result,cfg] = mvpalab_decoding(cfg,fv).
%  This function computes the cross-classification analysis, whatever the
%  value of cfg.analysis.

if nargin < 2, fv = []; end

warning('mvpalab:deprecated','mvpalab_mvcc is deprecated. Use mvpalab_decoding.');

cfg.analysis = 'MVCC';
[res,cfg] = mvpalab_decoding(cfg,fv);

end
