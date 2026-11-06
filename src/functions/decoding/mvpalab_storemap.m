function res = mvpalab_storemap(res,map,cfg,job)
%% MVPALAB_STOREMAP
%
%  This function stores the numeric metrics of one performance map in the
%  result structure. MVCC also stores the mean of the two directions.
%
%  The output must be assigned to the same variable used as input, so MATLAB
%  updates the result in place instead of copying it for each map.
%
%%  INPUT:
%
%  - {struct} - res:
%    Result structure.
%
%  - {struct} - map:
%    Numeric metrics of each direction (see mvpalab_averagereps).
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - res:
%    The same structure with the fields acc and auc: observed maps
%    [ntp x ntp_ x subjects x bands] or permuted maps
%    [ntp x ntp_ x subjects x maps x bands], with a single row in the
%    time-resolved analyses. In MVCC, fields ab, ba and their mean.

if job.permuted
    idx = {':',':',job.sub,job.per,job.freq};
else
    idx = {':',':',job.sub,job.freq};
end

for m = 1 : numel(job.numeric)
    metric = job.numeric{m};
    if job.mvcc
        ab = map.ab.(metric);
        ba = map.ba.(metric);
        res.(metric).ab(idx{:}) = orient(ab,cfg);
        res.(metric).ba(idx{:}) = orient(ba,cfg);
        res.(metric).mean(idx{:}) = orient(mean(cat(3,ab,ba),3),cfg);
    else
        res.(metric)(idx{:}) = orient(map.aa.(metric),cfg);
    end
end

end

function values = orient(values,cfg)
%% Time-resolved results have one row and one column per timepoint.

if ~cfg.classmodel.tempgen, values = values'; end

end
