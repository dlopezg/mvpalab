function res = mvpalab_packres(res,timepoints,cfg,job)
%% MVPALAB_PACKRES
%
%  This function completes the result structure of a decoding analysis with
%  the metrics stored per timepoint.
%
%%  INPUT:
%
%  - {struct} - res:
%    Result structure with the numeric metrics (see mvpalab_storemap).
%
%  - {cell array} - timepoints:
%    Metrics per timepoint of each map [subjects x bands x maps] (see
%    mvpalab_averagereps).
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
%    The same structure with the fields:
%    - roc, confmat: See mvpalab_reorganize_.
%    - precision, recall, f1score: See mvpalab_reorganize.
%    - wvector: See mvpalab_reorganize_weights. In MVCC, fields ab and ba.

for m = 1 : numel(job.lastrep)
    metric = job.lastrep{m};
    args = directions(timepoints,metric,job);
    res.roc.(metric) = mvpalab_reorganize_(cfg,args{:});
end

if any(strcmp(job.averaged,'confmat'))
    args = directions(timepoints,'confmat',job);
    res.confmat = mvpalab_reorganize_(cfg,args{:});
end

metrics = {'precision','recall','f1score'};
for m = 1 : numel(metrics)
    if any(strcmp(job.averaged,metrics{m}))
        args = directions(timepoints,metrics{m},job);
        res.(metrics{m}) = mvpalab_reorganize(cfg,args{:});
    end
end

if any(strcmp(job.averaged,'wvector'))
    args = directions(timepoints,'wvector',job);
    if job.mvcc
        res.wvector.ab = reorganizeweights(args{1});
        res.wvector.ba = reorganizeweights(args{2});
    else
        res.wvector = reorganizeweights(args{1});
    end
end

end

function args = directions(timepoints,metric,job)
%% Cell array {sub,tp,freq,per} of a metric, one per direction.

args = cell(1,numel(job.dirs));

for d = 1 : numel(job.dirs)
    for sub = 1 : size(timepoints,1)
        for freq = 1 : size(timepoints,2)
            for per = 1 : size(timepoints,3)
                values = timepoints{sub,freq,per}.(job.dirs{d}).(metric);
                for tp = 1 : numel(values)
                    args{d}{sub,tp,freq,per} = values{tp};
                end
            end
        end
    end
end

end

function wvector = reorganizeweights(weights)
%% The weights are indexed as {1,tp,sub,freq}.

wvector = mvpalab_reorganize_weights(permute(weights,[4 2 1 3]));

end
