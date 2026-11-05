function cfg = mvpalab_preparesf(cfg)

if isempty(cfg.sf.filesLocation)
    error('cfg.sf.filesLocation must be the folder for the filtered data.');
end

cfg.classmodel.tempgen = false; % Disable temporal generalization.
cfg.sf.flag = true; % Enable SF just in case.

cfg.sf.savefolder = [cfg.location filesep 'results' filesep 'diffMaps' filesep];
cfg = mvpalab_genfreqvec(cfg);  % Generate cutoff frequencies.
cfg = mvpalab_sfmetrics(cfg);   % Update performace metrics.

% If the filesLocation folder exists, remove the files of the previous
% analysis. This is required in order to prenvent errors if the user repeat
% the analysis with less frequency steps.

if exist(cfg.sf.filesLocation,'dir')
    mvpalab_cleansfdata(cfg);
end

mvpalab_mkdir(cfg.sf.filesLocation); % Create data folder.
mvpalab_mkdir(cfg.sf.savefolder);    % Create result folder.
mvpalab_mkdir([cfg.sf.savefolder 'other' filesep]);

end

