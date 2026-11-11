function diffMap = mvpalab_gendiffmap(cfg,baseline,bands,mode)
%% MVPALAB_GENDIFFMAP
%
%  This function computes the diffMaps of a sliding filter analysis: the
%  maps of each frequency band minus the unfiltered baseline, with the
%  bands in the first dimension. mvpalab_sfilter computes the observed
%  diffMaps and mvpalab_sfnullmaps the permuted ones, where each permuted
%  map of a band is compared with the permuted baseline of the same
%  permutation.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.sf.metric and cfg.study).
%
%  - {matrix} - baseline:
%    Unfiltered baseline [1 x ntp x subjects] or, permuted,
%    [1 x ntp x subjects x maps]. In MVCC, fields ab and ba.
%
%  - {matrix} - bands:
%    Maps of each band [1 x ntp x subjects x bands] or, permuted,
%    [1 x ntp x subjects x maps x bands]. In MVCC, fields ab and ba.
%
%  - {string} - mode:
%    'observed' or 'permuted'.
%
%%  OUTPUT:
%
%  - {struct} - diffMap:
%    Field cfg.sf.metric with the diffMaps [bands x ntp x subjects] or,
%    permuted, [bands x ntp x subjects x maps]. In MVCC, fields ab and ba.

fprintf('<strong> > Generating diffmaps... </strong>');

order = [4 2 3 1];
if strcmp(mode,'permuted'), order = [5 2 3 4 1]; end
difference = @(base,maps) permute(maps - base,order);

metric = cfg.sf.metric;
if mvpalab_ismvcc(cfg)
    diffMap.(metric).ab = difference(baseline.ab,bands.ab);
    diffMap.(metric).ba = difference(baseline.ba,bands.ba);
else
    diffMap.(metric) = difference(baseline,bands);
end

fprintf('Done.\n');

end
