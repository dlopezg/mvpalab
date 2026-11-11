function map = mvpalab_evalmap(cfg,data,job)
%% MVPALAB_EVALMAP
%
%  This function computes one performance map of the current subject and
%  frequency band: the mean across the cross-validation repetitions of the
%  performance at each timepoint.
%
%  The data of each repetition (supertrials, normalization and channels,
%  see mvpalab_preparedata) and its partitions are prepared once, before the
%  timepoints loop, and they are used at all the timepoints.
%
%  The labels of a permuted map belong to the single trials and do not
%  change across repetitions, so each repetition builds its supertrials
%  from them (see mvpalab_supertrials and mvpalab_permlabels).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - data:
%    Datasets of the subject (see mvpalab_subjectdata), with the labels of
%    this map. Single trials if cfg.trialaver.flag is enabled.
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - map:
%    Performance of each direction (see mvpalab_averagereps).

mvpalab_decodingprogress('repetitions',cfg,job);

perf = cell(cfg.tm.ntp,job.nreps);

%% Repeated cross-validation loop:
for rep = 1 : job.nreps
    job.rep = rep;

    %% Data of this repetition:
    prepared = mvpalab_preparedata(cfg,data,job.trimfolds);

    %% Stratified partition for cross validation:
    part = mvpalab_cvpartitions(cfg,prepared,job);

    %% Timepoints loop:
    if cfg.classmodel.parcomp
        parfor tp = 1 : cfg.tm.ntp
            perf{tp,rep} = mvpalab_evaltp(cfg,prepared,part,tp,job);
        end
    else
        for tp = 1 : cfg.tm.ntp
            perf{tp,rep} = mvpalab_evaltp(cfg,prepared,part,tp,job);
        end
    end

    mvpalab_decodingprogress('repetition',cfg,job);
end

%% Average metrics across repetitions:
map = mvpalab_averagereps(perf,job);

end
