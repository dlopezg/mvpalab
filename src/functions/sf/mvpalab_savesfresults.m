function mvpalab_savesfresults(cfg,performance_maps)

fprintf('<strong> > Saving performance maps: </strong>');

savefolder = [cfg.location filesep 'performance_maps' filesep];
mkadir(savefolder);
save([savefolder 'performance_maps.mat'],'performance_maps','-v7.3');

fprintf(' > Done! ');
fprintf('\n\n');

end

