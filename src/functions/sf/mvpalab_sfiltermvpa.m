function [cfg,diffMap,stats] = mvpalab_sfiltermvpa(cfg)
%% Initialize analysis:

savefolder = [cfg.location filesep 'results' filesep 'sfilter' filesep];
cfg.classmodel.tempgen = false; % Disable temporal generalization.
cfg = mvpalab_genfreqvec(cfg);  % Generate cutoff frequencies.
cfg = mvpalab_sfmetrics(cfg);   % Update performace metrics.

mvpalab_mkdir(cfg.sf.filesLocation); % Create data folder.
mvpalab_mkdir(savefolder);           % Create result folder.
mvpalab_mkdir([savefolder 'maps' filesep]);

%% Sliding filter analysis:

cfg = mvpalab_import(cfg);                   % Import and prepare data.
[performance_maps,cfg] = mvpalab_mvpa(cfg);  % Performance maps.
save([savefolder 'maps' filesep 'performance_maps.mat'],'performance_maps','-v7.3');

% Generate permuted maps for each frequency band if needed:
if cfg.stats.flag
    [permuted_maps,cfg] = mvpalab_permaps(cfg);
    save([savefolder 'maps' filesep 'permuted_maps.mat'],'permuted_maps','-v7.3');

end

%% MVPA analysis:

% Time-resolved MVPA:
cfg.sf.flag = false;
[cfg,~,fv] = mvpalab_import(cfg);
[performance,cfg] = mvpalab_mvpa(cfg,fv);
save([savefolder 'maps' filesep 'performance.mat'],'performance','-v7.3');

% Chance level:
cfg.classmodel.permlab = true;
[permuted_performance,cfg] = mvpalab_mvpa(cfg,fv);
cfg.classmodel.permlab = false;
save([savefolder 'maps' filesep 'permuted_performance.mat'],'permuted_performance','-v7.3');

%% Sliding filter analysis - Generate diffMaps:
[diffMap,perdiffMap,cfg] = mvpalab_gendiffmap(...
    cfg,performance.(cfg.sf.metric),...
    performance_maps.(cfg.sf.metric),...
    permuted_performance.(cfg.sf.metric),...
    permuted_maps.(cfg.sf.metric));

result = diffMap.(cfg.sf.metric);
save([savefolder 'result.mat'],'result','-v7.3');

%% Compute permutation test if needed Permutation test:
if cfg.stats.flag
    save([savefolder 'maps' filesep 'perdiffMap.mat'],'perdiffMap','-v7.3');
    stats = mvpalab_permtest(cfg,diffMap,perdiffMap);
    save([savefolder 'stats.mat'],'stats','-v7.3');
end
end

