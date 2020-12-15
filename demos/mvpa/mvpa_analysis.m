%% MVPAlab TOOLBOX - (mvpa_analysis.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% Initialize project and configure analysis:
cfg = mvpalab_init();
run mvpa_cfg;

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVPA analysis:
[result,cfg] = mvpalab_mvpa(cfg,fv);
mvpalab_saveresults(cfg,result);

%% Compute permutation maps and run statistical analysis:
[permaps,cfg] = mvpalab_permaps(cfg,fv);
mvpalab_savepermaps(cfg,permaps);

stats.cr = mvpalab_permtest(cfg,result.cr,permaps.cr);
mvpalab_savestats(cfg,stats);

%% Save cfg file:
mvpalab_savecfg(cfg);