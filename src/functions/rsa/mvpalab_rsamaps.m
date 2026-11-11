function maps = mvpalab_rsamaps(cfg,vrdm,vtheo,pidx)
%% MVPALAB_RSAMAPS
%
%  This function compares the empirical RDM of one subject with the
%  theoretical RDMs, as set in cfg.rsa.modality, for each map in pidx (the
%  observed map and the permuted maps, see mvpalab_rsapermidx):
%
%  - 'corr': Spearman correlation with each model, Fisher z-transformed
%    (see mvpalab_spearmanz).
%  - 'regress': a general linear model for each model (see mvpalab_glm).
%  - 'multiple_regress': one general linear model with all the models as
%    regressors.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.rsa).
%
%  - {matrix} - vrdm:
%    Vectorized empirical RDM [timepoints x pairs].
%
%  - {matrix} - vtheo:
%    Vectorized theoretical RDMs [pairs x models].
%
%  - {matrix} - pidx:
%    Order of the pairs of each map [maps x pairs].
%
%%  OUTPUT:
%
%  - {struct} - maps:
%    One field per model (cfg.rsa.tmodels{i}.id): the correlations
%    [timepoints x maps] in 'corr', or the fields bvalues and tvalues of
%    the same size.

ids = cellfun(@(model) model.id,cfg.rsa.tmodels,'UniformOutput',false);

if strcmp(cfg.rsa.modality,'multiple_regress')
    fprintf('\n<strong>   >> All the models</strong>\n');
    [b,t] = mvpalab_glm(vrdm,vtheo,pidx);
    for mdl = 1 : numel(ids)
        maps.(ids{mdl}).bvalues = b(:,:,mdl);
        maps.(ids{mdl}).tvalues = t(:,:,mdl);
    end
    return
end

for mdl = 1 : numel(ids)
    fprintf(['\n<strong>   >> Model: ' ids{mdl} '</strong>\n']);
    if strcmp(cfg.rsa.modality,'corr')
        maps.(ids{mdl}) = mvpalab_spearmanz(vrdm,vtheo(:,mdl),pidx);
    else
        [maps.(ids{mdl}).bvalues,maps.(ids{mdl}).tvalues] = ...
            mvpalab_glm(vrdm,vtheo(:,mdl),pidx);
    end
end

end
