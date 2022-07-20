function [] = mvpalab_savecfg(cfg)

if ~exist(cfg.location, 'dir'); mkdir(cfg.location); end
save([cfg.location filesep 'cfg.mat'],'cfg','-v7.3');

end
