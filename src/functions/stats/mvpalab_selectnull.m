function nullmaps = mvpalab_selectnull(cfg,res,permaps,chance)
%% MVPALAB_SELECTNULL
%
%  This function returns the maps of the null distribution of the
%  permutation test of an analysis (the input of mvpalab_permtest), as set
%  in cfg.stats.signflip:
%
%  - false: the permuted maps that the analysis computed (permaps).
%  - true: the result of each subject and its reflection around chance
%    (see mvpalab_signmaps). The analysis does not compute permuted maps,
%    so permaps is empty. Precision, recall and F1-score are left out:
%    they depend on the bias of the classifier towards one class, which
%    for example changes outside the diagonal in temporal generalization,
%    so they are not symmetric around chance.
%
%  The decoding (mvpalab_nullmaps, chance 1 over the number of classes),
%  RSA (mvpalab_rsa_time, chance 0) and the sliding filter
%  (mvpalab_sfilter, chance 0) call it, so the choice is made in one
%  place. The fusion has no sign flip test (see mvpalab_fusion).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.stats.signflip).
%
%  - {struct} - res:
%    Result of the analysis.
%
%  - {struct} - permaps:
%    Permuted maps of the analysis, or empty with cfg.stats.signflip.
%
%  - {double} - chance:
%    Chance level of the result, the center of the reflection.
%
%%  OUTPUT:
%
%  - {struct} - nullmaps:
%    Maps of the null distribution of each result.

if ~cfg.stats.signflip
    nullmaps = permaps;
    return
end

classmetrics = intersect(fieldnames(res),{'precision','recall','f1score'});
nullmaps = mvpalab_signmaps(cfg,rmfield(res,classmetrics),chance);

end
