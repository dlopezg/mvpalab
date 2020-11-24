function [] = mvpalab_savepermaps(cfg,pmaps)

    permaps = pmaps.cr;
    save([cfg.study.studyLocation filesep 'results' filesep ...
        'macc' filesep 'permaps.mat'],'permaps','-v7.3');

    if cfg.classmodel.roc
        permaps = pmaps.auc;
        save([cfg.study.studyLocation filesep 'results' filesep ...
            'auc' filesep 'permaps.mat'],'permaps','-v7.3');
    end
end

