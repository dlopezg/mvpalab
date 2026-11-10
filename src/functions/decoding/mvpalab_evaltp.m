function perf = mvpalab_evaltp(cfg,data,part,tp,job)
%% MVPALAB_EVALTP
%
%  This function evaluates one timepoint in all the directions of the
%  analysis.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - data:
%    Datasets of the subject (see mvpalab_subjectdata).
%
%  - {struct} - part:
%    Cross-validation partitions (see mvpalab_cvpartitions).
%
%  - {int} - tp:
%    Timepoint.
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - perf:
%    Performance of each direction (perf.aa or perf.ab and perf.ba) with
%    the metrics that are needed (job.keep). The ROC curves are only kept
%    in the last repetition, so they do not accumulate in memory.

for d = 1 : numel(job.dirs)
    way = job.dirs{d};
    perf.(way) = mvpalab_evalfolds(cfg,data.(way(1)),data.(way(2)),...
        part.(way),tp,job);
    perf.(way) = rmfield(perf.(way),setdiff(fieldnames(perf.(way)),job.keep));
    if job.rep < job.nreps
        for m = 1 : numel(job.lastrep)
            perf.(way).(job.lastrep{m}) = [];
        end
    end
end

end
