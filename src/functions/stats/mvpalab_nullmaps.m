function [maps,cfg] = mvpalab_nullmaps(cfg,fv,res)
%% MVPALAB_NULLMAPS
%
%  This function returns the maps of the statistical test of a decoding
%  analysis, the input of mvpalab_permtest:
%
%  - cfg.stats.signflip = false: permuted maps of each subject (see
%    mvpalab_decoding).
%  - cfg.stats.signflip = true: the result of each subject and its
%    reflection around chance (see mvpalab_signmaps). Chance is one over
%    the number of classes for accuracy and 0.5 for AUC, which is only
%    available with two classes, so the classes must have the same size.
%    Precision, recall and F1-score are not tested: they depend on the bias
%    of the classifier towards one class, which for example changes outside
%    the diagonal in temporal generalization, so they are not symmetric
%    around chance.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - fv:
%    Feature vectors of each subject.
%
%  - {struct} - res:
%    Result of the decoding analysis.
%
%%  OUTPUT:
%
%  - {struct} - maps:
%    Maps of each performance metric.
%
%  - {struct} - cfg:
%    Updated configuration structure.

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

if cfg.stats.signflip
    chance = 1/size(cfg.study.dataFiles,2);
    if ~cfg.classsize.match
        warning(['The sign flip test assumes a chance level of %.3g. Enable ' ...
            'cfg.classsize.match if the classes have different sizes.'],chance);
    end
    classmetrics = intersect(fieldnames(res),{'precision','recall','f1score'});
    maps = mvpalab_signmaps(rmfield(res,classmetrics),chance);
    % Enable statistics, as the permuted maps do:
    cfg.stats.flag = 1;
else
    [maps,cfg] = mvpalab_decoding(cfg,fv,'permuted');
end

end
