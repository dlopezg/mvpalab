function cfg = mvpalab_preparesf(cfg)
%% MVPALAB_PREPARESF
%
%  This function prepares the configuration of a sliding filter analysis
%  when its data is imported (see mvpalab_import):
%
%  - It disables temporal generalization (cfg.classmodel.tempgen).
%  - It generates the frequency bands (see mvpalab_genfreqvec) and selects
%    the performance metrics (see mvpalab_sfmetrics).
%
%  The folders of the filtered data are created by mvpalab_sffolders, and
%  the folder of the results by mvpalab_sfilter.
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

cfg = mvpalab_genfreqvec(cfg);  % Generate cutoff frequencies.
cfg = mvpalab_sfmetrics(cfg);   % Update performace metrics.

end
