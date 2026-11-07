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
%  - {matrix} - acc, peracc:
%    Observed [1 x ntp x subjects] and permuted [1 x ntp x subjects x maps]
%    baseline. In MVCC, fields ab and ba.
%
%  - {matrix} - accmap, permaps:
%    Observed [1 x ntp x subjects x bands] and permuted
%    [1 x ntp x subjects x maps x bands] maps of each band. In MVCC, fields
%    ab and ba.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - diffMap, perdiffMap:
%    Field cfg.sf.metric with the observed [bands x ntp x subjects] and
%    permuted [bands x ntp x subjects x maps] diffMaps. In MVCC, fields ab
%    and ba.

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
