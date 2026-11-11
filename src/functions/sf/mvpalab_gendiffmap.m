function [cfg,diffMap,perdiffMap] = mvpalab_gendiffmap(cfg,acc,accmap,peracc,permaps)
%% MVPALAB_GENDIFFMAP
%
%  This function computes the diffMaps of a sliding filter analysis: the
%  filtered maps minus the unfiltered baseline, and the same with the
%  permuted maps if they are provided.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {matrix} - acc:
%    Observed baseline [1 x ntp x subjects]. In MVCC, fields ab and ba.
%
%  - {matrix} - accmap:
%    Observed map of each band [1 x ntp x subjects x bands]. In MVCC,
%    fields ab and ba.
%
%  - {matrix} - peracc:
%    Optional. Permuted baseline [1 x ntp x subjects x maps]. In MVCC,
%    fields ab and ba.
%
%  - {matrix} - permaps:
%    Optional. Permuted maps of each band
%    [1 x ntp x subjects x maps x bands]. In MVCC, fields ab and ba.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - diffMap:
%    Field cfg.sf.metric with the observed diffMaps
%    [bands x ntp x subjects]. In MVCC, fields ab and ba.
%
%  - {struct} - perdiffMap:
%    Field cfg.sf.metric with the permuted diffMaps
%    [bands x ntp x subjects x maps], if peracc and permaps are given. In
%    MVCC, fields ab and ba.

fprintf('<strong> > Generating diffmaps... </strong>');

metric = cfg.sf.metric;
mvcc = strcmp(cfg.analysis,'MVCC');

%% Generate diffMap for real data:
order = [4 2 3 1];
if mvcc
    diffMap.(metric).ab = permute(accmap.ab - acc.ab,order);
    diffMap.(metric).ba = permute(accmap.ba - acc.ba,order);
else
    diffMap.(metric) = permute(accmap - acc,order);
end

%% Generate permuted diffMaps for statistics if nedeed:
if nargin > 3
    order = [5 2 3 4 1];
    if mvcc
        perdiffMap.(metric).ab = permute(permaps.ab - peracc.ab,order);
        perdiffMap.(metric).ba = permute(permaps.ba - peracc.ba,order);
    else
        perdiffMap.(metric) = permute(permaps - peracc,order);
    end
end

fprintf('Done.\n');

end
