function [cfg,diffMap,stats] = mvpalab_sfilter(cfg)

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

% Only computed if cfg.stats.flag is enabled:
stats = [];

%% Sliding filter analysis:

% Compute analysis for each frequency band:
if strcmp(cfg.analysis,'MVPA')
    [performance_maps,cfg] = mvpalab_mvpa(cfg);
elseif strcmp(cfg.analysis,'MVCC')
    [performance_maps,cfg] = mvpalab_mvcc(cfg);
end

save([cfg.sf.savefolder 'other' filesep 'performance_maps.mat'],...
    'performance_maps','-v7.3');

% Generate permuted maps for each frequency band if needed:
if cfg.stats.flag
    if strcmp(cfg.analysis,'MVPA')
        [permuted_maps,cfg] = mvpalab_permaps(cfg);
    elseif strcmp(cfg.analysis,'MVCC')
        [permuted_maps,cfg] = mvpalab_cpermaps(cfg);
    end
    save([cfg.sf.savefolder 'other' filesep 'permuted_maps.mat'],...
        'permuted_maps','-v7.3');
end

%% MVPA analysis:

% Time-resolved MVPA (unfiltered baseline):
cfg.sf.flag = false;
cfg.sf.baseline = true;
[cfg,~,fv] = mvpalab_import(cfg);

if strcmp(cfg.analysis,'MVPA')
    [performance,cfg] = mvpalab_mvpa(cfg,fv);
elseif strcmp(cfg.analysis,'MVCC')
    [performance,cfg] = mvpalab_mvcc(cfg,fv);
end

save([cfg.sf.savefolder 'other' filesep 'performance.mat'],...
    'performance','-v7.3');

% Chance level if needed:
%  One permuted map of the unfiltered data for each permutation, so every
%  permuted diffMap has its own baseline (see mvpalab_gendiffmap).
if cfg.stats.flag

    if strcmp(cfg.analysis,'MVPA')
        [permuted_performance,cfg] = mvpalab_permaps(cfg,fv);
    elseif strcmp(cfg.analysis,'MVCC')
        [permuted_performance,cfg] = mvpalab_cpermaps(cfg,fv);
    end

    save([cfg.sf.savefolder 'other' filesep 'permuted_performance.mat'],...
        'permuted_performance','-v7.3');
end

cfg.sf.flag = true;
cfg.sf.baseline = false;
mvpalab_savecfg(cfg);

%% Sliding filter analysis - Generate diffMaps:

if cfg.stats.flag
    [cfg,diffMap,perdiffMap] = mvpalab_gendiffmap(...
        cfg,performance.(cfg.sf.metric),...
        performance_maps.(cfg.sf.metric),...
        permuted_performance.(cfg.sf.metric),...
        permuted_maps.(cfg.sf.metric));
else
    [cfg,diffMap] = mvpalab_gendiffmap(...
        cfg,performance.(cfg.sf.metric),...
        performance_maps.(cfg.sf.metric));
end

result = diffMap.(cfg.sf.metric);
save([cfg.sf.savefolder 'result.mat'],'result','cfg','-v7.3');

%% Compute permutation test if needed:
if cfg.stats.flag
    save([cfg.sf.savefolder 'other' filesep 'perdiffMap.mat'],...
        'perdiffMap','-v7.3');
    stats = mvpalab_permtest(cfg,diffMap,perdiffMap);
    stats = stats.(cfg.sf.metric);
    save([cfg.sf.savefolder 'stats.mat'],'stats','-v7.3');
end

end

