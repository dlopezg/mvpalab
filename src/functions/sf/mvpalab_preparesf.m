function cfg = mvpalab_preparesf(cfg)
%% MVPALAB_PREPARESF
%
%  This function prepares the configuration of a sliding filter analysis
%  (see mvpalab_preparestudy):
%
%  - It disables temporal generalization (cfg.classmodel.tempgen).
%  - It sets the result folder cfg.sf.savefolder (results/diffMaps/ in
%    cfg.location).
%  - It generates the frequency bands (see mvpalab_genfreqvec) and selects
%    the performance metrics (see mvpalab_sfmetrics).
%
%  The folders are created by mvpalab_sffolders.
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

cfg.classmodel.tempgen = false; % Disable temporal generalization.

cfg.sf.savefolder = [cfg.location filesep 'results' filesep 'diffMaps' filesep];
cfg = mvpalab_genfreqvec(cfg);  % Generate cutoff frequencies.
cfg = mvpalab_sfmetrics(cfg);   % Update performace metrics.

end
