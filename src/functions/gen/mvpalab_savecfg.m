function [] = mvpalab_savecfg(cfg)
    save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');
end

