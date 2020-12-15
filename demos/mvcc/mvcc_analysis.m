%% MVPAlab TOOLBOX - (mvcc_analysis.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% Initialize project and configure analysis:
cfg = mvpalab_init();
run mvcc_cfg;

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVCC analysis:
[result,cfg] = mvpalab_mvcc(cfg,fv);
mvpalab_saveresults(cfg,result);

%% Compute permutation maps and run statistical analysis y both directions:
[permaps,cfg] = mvpalab_cpermaps(cfg,fv);
mvpalab_savepermaps(cfg,permaps);

stats.cr.ab = mvpalab_permtest(cfg,result.cr.ab,permaps.cr.ab);
stats.cr.ba = mvpalab_permtest(cfg,result.cr.ba,permaps.cr.ba);
mvpalab_savestats(cfg,stats);

%% Save cfg file:
mvpalab_savecfg(cfg);