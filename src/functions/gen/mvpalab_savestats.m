function [] = mvpalab_savestats(cfg,statistics)

stats = statistics.cr;
save([cfg.location filesep 'results' filesep ...
    'macc' filesep 'stats.mat'],'stats','-v7.3');

if cfg.classmodel.roc
    stats = statistics.auc;
    save([cfg.location filesep 'results' filesep ...
        'auc' filesep 'stats.mat'],'stats','-v7.3');
end
end

