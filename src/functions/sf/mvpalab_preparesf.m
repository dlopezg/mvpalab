function cfg = mvpalab_preparesf(cfg)

cfg.classmodel.tempgen = false; % Disable temporal generalization.
cfg.sf.flag = true; % Enable SF just in case.

cfg.sf.savefolder = [cfg.location filesep 'results' filesep 'diffMaps' filesep];
cfg = mvpalab_genfreqvec(cfg);  % Generate cutoff frequencies.
cfg = mvpalab_sfmetrics(cfg);   % Update performace metrics.

mvpalab_mkdir(cfg.sf.filesLocation); % Create data folder.
mvpalab_mkdir(cfg.sf.savefolder);    % Create result folder.
mvpalab_mkdir([cfg.sf.savefolder 'other' filesep]);

end

