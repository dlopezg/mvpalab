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
%    Performance of each direction (aa or ab and ba):
%    - map.numeric.(direction).(metric): Metrics in job.numeric and
%      job.perclass, matrices [ntp x 1] or, in temporal generalization,
%      [ntp x ntp_], with the classes in the third dimension.
%    - map.timepoints.(direction).(metric): Metrics in job.averaged and
%      job.lastrep, cell arrays with the value at each timepoint.

map.timepoints = struct();
perf = reshape([perf{:}],size(perf));

for d = 1 : numel(job.dirs)
    way = job.dirs{d};
    reps = reshape([perf.(way)],size(perf));

    numeric = [job.numeric job.perclass];
    for m = 1 : numel(numeric)
        metric = numeric{m};
        map.numeric.(way).(metric) = meannumeric(reps,metric);
    end

    for m = 1 : numel(job.averaged)
        metric = job.averaged{m};
        for tp = 1 : size(reps,1)
            map.timepoints.(way).(metric){tp} = ...
                mvpalab_meanreps({reps(tp,:).(metric)});
        end
    end

    for m = 1 : numel(job.lastrep)
        metric = job.lastrep{m};
        map.timepoints.(way).(metric) = {reps(:,end).(metric)};
    end
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
