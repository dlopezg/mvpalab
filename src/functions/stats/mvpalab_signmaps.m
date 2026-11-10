function maps = mvpalab_signmaps(cfg,res,chance)
%% MVPALAB_SIGNMAPS
%
%  This function returns the maps of the sign flip test: a one-sample test
%  against the chance level with the group-level permutations of
%  mvpalab_permtest, enabled with cfg.stats.signflip.
%
%  Each subject has two maps: its result and its result reflected around
%  the chance level, so choosing one of them at random for each subject
%  flips the sign of its difference with chance. The whole map of a subject
%  is flipped, so its temporal structure does not change. The null
%  distribution comes from the real differences between subjects and no
%  classification is repeated.
%
%  The maps with most signs unchanged keep part of a real effect, so the
%  null distribution of all the cluster sizes ('fdr') grows with the effect
%  and a strong effect stops being significant. This test needs the maximum
%  cluster size (cfg.stats.clustcorr = 'max').
%
%  This test only needs the result to be symmetric around chance when
%  there is no effect at the group level. It does not need the labels to be
%  exchangeable, which they are not in MVCC if datasets A and B contain
%  effects that are not shared (see mvpalab_decoding). It tests the mean of
%  the group, so a significant result does not imply that the effect is
%  present in the population, and the number of sign combinations limits
%  the smallest p-value with few subjects.
%
%%  REFERENCES:
%
%  - Maris, E., & Oostenveld, R. (2007). Nonparametric statistical testing
%    of EEG- and MEG-data. Journal of Neuroscience Methods, 164(1),
%    177-190. https://doi.org/10.1016/j.jneumeth.2007.03.024
%
%  - Allefeld, C., Gorgen, K., & Haynes, J. D. (2016). Valid population
%    inference for information-based imaging: from the second-level t-test
%    to prevalence inference. NeuroImage, 141, 378-392.
%    https://doi.org/10.1016/j.neuroimage.2016.07.040
%
%  It shows a warning if there are too few subjects for anything to be
%  significant (see mvpalab_checksignflip).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.stats).
%
%  - {struct} - res:
%    Result structure, with the fields of mvpalab_permtest.
%
%  - {double} - chance:
%    Value of the metrics without effect.
%
%%  OUTPUT:
%
%  - {struct} - maps:
%    Structure with the same fields, where each matrix gets a fourth
%    dimension of size 2, as the permuted maps. Cell arrays, such as the
%    RDMs or the confusion matrices, are not maps and are left out, and so
%    are the structures that only contain them, such as the ROC curves and
%    the feature weights (see mvpalab_permtest).

maps = reflect(res,chance);
mvpalab_checksignflip(cfg,observations(maps));

end

function maps = reflect(res,chance)
%% The maps of each field with their reflection around chance.

if ~isstruct(res)
    maps = cat(4,res,2*chance - res);
    return
end

maps = struct();
fields = fieldnames(res);
for i = 1 : numel(fields)
    field = res.(fields{i});
    if iscell(field), continue; end
    fieldmaps = reflect(field,chance);
    if isstruct(fieldmaps) && isempty(fieldnames(fieldmaps)), continue; end
    maps.(fields{i}) = fieldmaps;
end

end

function n = observations(maps)
%% Number of subjects: the third dimension of the first map.

while isstruct(maps)
    fields = fieldnames(maps);
    maps = maps.(fields{1});
end
n = size(maps,3);

end
