function pidx = mvpalab_rsapermidx(cfg,nvec,permuted)
%% MVPALAB_RSAPERMIDX
%
%  This function returns the order of the pairs of conditions of each map
%  of a representational similarity analysis: the identity for the
%  observed map and, if needed, one permutation of the conditions for each
%  of the cfg.stats.nper permuted maps (see mvpalab_permidx). The observed
%  map is the permuted map with the identity, so both are computed in the
%  same way.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.stats.nper).
%
%  - {int} - nvec:
%    Number of pairs of conditions of the vectorized RDMs.
%
%  - {logical} - permuted:
%    True if the permuted maps are needed.
%
%%  OUTPUT:
%
%  - {matrix} - pidx:
%    Order of the pairs of each map [maps x pairs]: the first row is the
%    observed map.

pidx = 1 : nvec;
if permuted, pidx = [pidx; mvpalab_permidx(nvec,cfg.stats.nper)]; end

end
