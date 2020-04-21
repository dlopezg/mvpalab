function [] = mvpalab_saveresults( cfg, result, permaps, stats )
%MVPALAB_SAVERESULTS Summary of this function goes here
%   Detailed explanation goes here
save([cfg.dir.savedir 'results'],'result','stats','cfg','-v7.3');
save([cfg.dir.savedir 'permaps'],'permaps','cfg','-v7.3');
end

