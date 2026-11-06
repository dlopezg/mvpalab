function map = mvpalab_decodemap(cfg,data,job)
%% MVPALAB_DECODEMAP
%
%  This function computes one performance map of the current subject and
%  frequency band: the mean across the cross-validation repetitions of the
%  performance at each timepoint.
%
%  The supertrials and the partitions are drawn once per repetition, before
%  the timepoints loop, and they are used at all the timepoints.
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
%    Datasets of the subject (see mvpalab_loadfv), with the labels of this
%    map. Single trials if cfg.trialaver.flag is enabled.
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - map:
%    Performance of each direction (see mvpalab_averagereps).

mvpalab_decodingprint('repetitions',cfg,job);

perf = cell(cfg.tm.ntp,job.nreps);

%% Repeated cross-validation loop:
for rep = 1 : job.nreps
    job.rep = rep;

    %% Supertrials of this repetition:
    repdata = mvpalab_repdata(cfg,data);

    %% Stratified partition for cross validation:
    part = mvpalab_cvpartitions(cfg,repdata,job);

    %% Timepoints loop:
    if cfg.classmodel.parcomp
        parfor tp = 1 : cfg.tm.ntp
            perf{tp,rep} = mvpalab_evaltp(cfg,repdata,part,tp,job);
        end
    else
        for tp = 1 : cfg.tm.ntp
            perf{tp,rep} = mvpalab_evaltp(cfg,repdata,part,tp,job);
        end
    end

    mvpalab_decodingprint('repetition',cfg,job);
end

%% Average metrics across repetitions:
map = mvpalab_averagereps(perf,job);

end
