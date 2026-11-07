function res = mvpalab_storemap(res,map,cfg,job)
%% MVPALAB_STOREMAP
%
%  This function stores the metrics of one performance map in the result
%  structure. MVCC also stores the mean of the two directions in the numeric
%  metrics and the metrics of each class.
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
%    Metrics of each direction (see mvpalab_averagereps).
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
%    The same structure with the metrics in fields per direction: aa, or ab,
%    ba and their mean in MVCC (see mvpalab_packres):
%    - acc, auc: Observed maps [ntp x ntp_ x subjects x bands] or permuted
%      maps [ntp x ntp_ x subjects x maps x bands], with a single row in
%      the time-resolved analyses.
%    - roc.x, roc.y, roc.t, confmat: Cell arrays
%      [ntp x ntp_ x subjects x bands], with a single row in the
%      time-resolved analyses.
%    - precision, recall, f1score: The same maps as acc, one field per
%      class and the mean of the classes (see job.classes).
%    - wvector: Fields raw and haufe_corrected, cell arrays
%      {subjects,bands} with matrices [channels x ntp].

if job.permuted
    idx = {':',':',job.sub,job.per,job.freq};
else
    idx = {':',':',job.sub,job.freq};
end

for d = 1 : numel(job.dirs)
    way = job.dirs{d};

    for m = 1 : numel(job.numeric)
        metric = job.numeric{m};
        res.(metric).(way)(idx{:}) = orient(map.(way).(metric),cfg);
    end

    for m = 1 : numel(job.lastrep)
        metric = job.lastrep{m};
        res.roc.(metric).(way)(idx{:}) = orient(map.(way).(metric),cfg);
    end

    if job.confmat
        res.confmat.(way)(idx{:}) = orient(map.(way).confmat,cfg);
    end

    for m = 1 : numel(job.perclass)
        metric = job.perclass{m};
        maps = classmaps(map.(way).(metric),cfg);
        names = job.classes.(way);
        for class = 1 : numel(names)
            res.(metric).(way).(names{class})(idx{:}) = maps(:,:,class);
        end
    end

    if job.wvector
        weights = map.(way).wvector;
        res.wvector.(way).raw{job.sub,job.freq} = weights.raw;
        res.wvector.(way).haufe_corrected{job.sub,job.freq} = weights.haufe_corrected;
    end
end

if ~job.mvcc, return; end

for m = 1 : numel(job.numeric)
    metric = job.numeric{m};
    res.(metric).mean(idx{:}) = orient((map.ab.(metric) + map.ba.(metric))/2,cfg);
end

% The names of dataset A, as in the direction B - A:
for m = 1 : numel(job.perclass)
    metric = job.perclass{m};
    maps = (classmaps(map.ab.(metric),cfg) + classmaps(map.ba.(metric),cfg))/2;
    names = job.classes.ba;
    for class = 1 : numel(names)
        res.(metric).mean.(names{class})(idx{:}) = maps(:,:,class);
    end
end

end

function maps = classmaps(values,cfg)
%% Maps of each class, with the mean of the classes in the last page.

maps = orient(values,cfg);
maps = cat(3,maps,mean(maps,3));

end

function values = orient(values,cfg)
%% Time-resolved results have one row and one column per timepoint.

if ~cfg.classmodel.tempgen, values = permute(values,[2 1 3]); end

end
