function [] = mvpalab_savecfg(cfg)
    save([cfg.location filesep 'cfg.mat'],'cfg','-v7.3');
end

