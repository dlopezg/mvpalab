function cfg = mvpalab_sfrng(cfg,job)
%% MVPALAB_SFRNG
%
%  This function aligns the random draws of a sliding filter analysis. The
%  first frequency band of each subject stores the state of the random
%  number generator, and the rest of the bands and the unfiltered baseline
%  restore it. All of them use the same supertrials, partitions and permuted
%  labels, so a diffMap only contains the effect of the filter, and the
%  labels of a permuted map are the same across frequencies.
%
%  Observed and permuted maps store different states (see mvpalab_sfilter).
%  It does nothing out of mvpalab_sfilter.
%
%  Limitation: the draws of the hyperparameter search (cfg.classmodel.optimize)
%  are inside the timepoints loop and they are not shared, so a diffMap also
%  contains their noise. Without cfg.classmodel.parcomp they use the same
%  generator, and a search with a variable number of draws can misalign the
%  following supertrials, partitions and labels.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure. cfg.sf.rng has one row per subject,
%    and one column for the observed maps and one for the permuted maps.

if ~isfield(cfg.sf,'rng'), return; end

stage = 1 + job.permuted;

if isempty(cfg.sf.rng{job.sub,stage})
    cfg.sf.rng{job.sub,stage} = rng;
else
    rng(cfg.sf.rng{job.sub,stage});
end

end
