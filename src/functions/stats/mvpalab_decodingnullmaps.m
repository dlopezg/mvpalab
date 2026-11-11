function [maps,cfg] = mvpalab_decodingnullmaps(cfg,fv,res)
%% MVPALAB_NULLMAPS
%
%  This function returns the maps of the statistical test of a decoding
%  analysis, the input of mvpalab_permtest. Without cfg.stats.signflip it
%  computes the permuted maps of each subject (see mvpalab_decoding); with
%  it, the maps of the sign flip test. mvpalab_selectnull chooses between
%  them, as in the other analyses.
%
%  mvpalab_decoding calls it with cfg.stats.flag enabled, with its own cfg,
%  so the null maps always follow the settings of the result. To call it
%  separately, use the cfg returned by mvpalab_decoding.
%
%  The chance level of the sign flip test is one over the number of
%  classes for accuracy and 0.5 for AUC, which is only available with two
%  classes, so the classes must have the same size: a warning is shown if
%  cfg.classsize.match is disabled.
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
cfg = mvpalab_updatecfg(cfg);

chance = 1/size(cfg.study.dataFiles,2);
permaps = [];
if ~cfg.stats.signflip
    [permaps,cfg] = mvpalab_decoding(cfg,fv,'permuted');
elseif ~cfg.classsize.match
    warning(['The sign flip test assumes a chance level of %.3g. Enable ' ...
        'cfg.classsize.match if the classes have different sizes.'],chance);
end

maps = mvpalab_selectnull(cfg,res,permaps,chance);

end
