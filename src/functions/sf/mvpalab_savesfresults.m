function mvpalab_savesfresults(cfg,performance_maps)
savefolder = [cfg.location filesep 'performance_maps' filesep];
mkadir(savefolder);
save([savefolder 'performance_maps.mat'],'performance_maps','-v7.3');
end

