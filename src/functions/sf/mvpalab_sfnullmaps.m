function [nullmaps,cfg] = mvpalab_sfnullmaps(cfg,diffMap)
%% MVPALAB_SFNULLMAPS
%
%  This function returns the maps of the null distribution of the
%  permutation test of a sliding filter analysis (see mvpalab_sfilter),
%  the input of mvpalab_permtest:
%
%  - Without cfg.stats.signflip, the permuted diffMaps: the permuted maps
%    of each band minus the permuted map of the unfiltered baseline of the
%    same permutation (see mvpalab_gendiffmap). The bands and the baseline
%    share their random draws (see mvpalab_sfrng): each permuted map uses
%    the same permuted labels, supertrials and partitions in every band
%    and in the baseline, so a permuted diffMap only contains the effect of
%    the filter under the null hypothesis, as the observed diffMap. The
%    permuted maps are saved with mvpalab_save, and the maps of the bands
%    and of the baseline in other/permuted_maps.mat and
%    other/permuted_performance.mat, with cfg.
%  - With cfg.stats.signflip, the sign flip maps of the diffMaps around 0
%    (see mvpalab_selectnull).
%
%  mvpalab_sfilter calls it with cfg.stats.flag enabled, with its own cfg,
%  so the null maps always follow the settings of the result. To call it
%  separately, use the cfg returned by mvpalab_sfilter. The filtered data
%  on disk is checked: it must come from the same import, with the same
%  settings (see mvpalab_validatesfimport and mvpalab_subjectdata).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure returned by mvpalab_sfilter.
%
%  - {struct} - diffMap:
%    Result of mvpalab_sfilter.
%
%%  OUTPUT:
%
%  - {struct} - nullmaps:
%    Field cfg.sf.metric with the null diffMaps
%    [bands x ntp x subjects x maps]. In MVCC, fields ab, ba and mean.
%
%  - {struct} - cfg:
%    Configuration structure.

cfg = mvpalab_updatecfg(cfg);
mvpalab_validatestats(cfg);
mvpalab_validatesignflip(cfg);
mvpalab_validatesfimport(cfg);

permaps = [];
if ~cfg.stats.signflip
    % The permuted maps of the bands and of the baseline share their draws:
    cfg.sf.rng = cell(length(cfg.study.dataFiles{1,1}),2);

    [permuted_maps,cfg] = mvpalab_evalsubjects(cfg,[],'permuted');

    cfg.sf.flag = false;
    [fv,cfg] = mvpalab_sfbaseline(cfg);
    [permuted_performance,cfg] = mvpalab_evalsubjects(cfg,fv,'permuted');

    cfg.sf = rmfield(cfg.sf,'rng');
    cfg.sf.flag = true;

    % Permuted maps of the bands and of the baseline, with cfg:
    save(fullfile(cfg.savefolder,'other','permuted_maps.mat'),...
        'permuted_maps','cfg','-v7.3');
    save(fullfile(cfg.savefolder,'other','permuted_performance.mat'),...
        'permuted_performance','cfg','-v7.3');

    permaps = mvpalab_gendiffmap(cfg,permuted_performance.(cfg.sf.metric),...
        permuted_maps.(cfg.sf.metric),'permuted');
    mvpalab_save(cfg,permaps,'permaps');
end

% Permuted or sign flip diffMaps; the diffMaps have no effect at 0:
nullmaps = mvpalab_selectnull(cfg,diffMap,permaps,0);

end
