function cfg = mvpalab_preparesf(cfg)
%% MVPALAB_PREPARESF
%
%  This function prepares a sliding filter analysis. mvpalab_readdata calls
%  it when cfg.sf.flag is enabled. It changes cfg:
%
%  - It disables temporal generalization (cfg.classmodel.tempgen) and
%    enables cfg.sf.flag.
%  - It sets the result folder cfg.sf.savefolder (results/diffMaps/ in
%    cfg.location).
%  - It generates the frequency bands (see mvpalab_genfreqvec) and selects
%    the performance metrics (see mvpalab_sfmetrics).
%
%  If the folder cfg.sf.filesLocation exists, it removes the filtered data
%  of a previous analysis (see mvpalab_cleansfdata). Then it creates
%  cfg.sf.filesLocation, cfg.sf.savefolder and its subfolder 'other'. It
%  stops with an error if cfg.sf.filesLocation is empty.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure.

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

