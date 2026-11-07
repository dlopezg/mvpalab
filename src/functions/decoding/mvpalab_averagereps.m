function map = mvpalab_averagereps(perf,job)
%% MVPALAB_AVERAGEREPS
%
%  This function averages the performance of each direction across the
%  cross-validation repetitions. The ROC curves are not averaged: they come
%  from the last repetition.
%
%%  INPUT:
%
%  - {cell array} - perf:
%    Performance of each timepoint and repetition [ntp x nreps] (see
%    mvpalab_evaltp).
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - map:
%    Performance of each direction, map.(direction).(metric):
%    - Metrics in job.numeric and job.perclass: Matrices [ntp x 1] or, in
%      temporal generalization, [ntp x ntp_], with the classes in the third
%      dimension.
%    - confmat and metrics in job.lastrep: Cell arrays of the same size.
%    - wvector: Fields raw and haufe_corrected, [channels x ntp].

perf = reshape([perf{:}],size(perf));

for d = 1 : numel(job.dirs)
    way = job.dirs{d};
    reps = reshape([perf.(way)],size(perf));

    numeric = [job.numeric job.perclass];
    for m = 1 : numel(numeric)
        metric = numeric{m};
        map.(way).(metric) = meannumeric(reps,metric);
    end

    for m = 1 : numel(job.lastrep)
        metric = job.lastrep{m};
        map.(way).(metric) = vertcat(reps(:,end).(metric));
    end

    if job.confmat, map.(way).confmat = meanconfmat(reps); end
    if job.wvector, map.(way).wvector = meanweights(reps); end
end

end

function values = meannumeric(reps,metric)
%% Mean of a numeric metric: one row per timepoint, the classes in the third
%  dimension and the repetitions in the fourth.

for rep = 1 : size(reps,2)
    values(:,:,:,rep) = vertcat(reps(:,rep).(metric));
end

values = mean(values,4);

end

function cells = meanconfmat(reps)
%% Mean confusion matrix at each timepoint and test timepoint, in one cell.

for rep = 1 : size(reps,2)
    for tp = 1 : size(reps,1)
        values(:,:,:,tp,rep) = reps(tp,rep).confmat;
    end
end

cells = permute(num2cell(mean(values,5),[1 2]),[4 3 1 2]);

end

function weights = meanweights(reps)
%% Mean feature weights: one column per timepoint, one page per repetition.

perrep = reshape([reps.wvector],size(reps));

for f = {'raw','haufe_corrected'}
    for rep = 1 : size(perrep,2)
        values(:,:,rep) = [perrep(:,rep).(f{1})];
    end
    weights.(f{1}) = mean(values,3);
end

end
