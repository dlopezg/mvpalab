%% MVPAlab TOOLBOX - (mvpa_tempgen_analysis.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% Initialize project and configure analysis:
cfg = mvpalab_init();
run mvpa_tempgen_cfg;

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

%% OPTION 1: Extract diagonal (NO STATS):
% resultdiag.cr = mvpalab_extractdiag(result.cr);
% mvpalab_savediag(cfg,resultdiag);

%% OPTION 2: Extract diagonal and permutation test:
[resultdiag.cr,permapsdiag.cr] = mvpalab_extractdiag(result.cr,permaps.cr);
statsdiag.cr = mvpalab_permtest(cfg,resultdiag.cr,permapsdiag.cr);
mvpalab_savediag(cfg,resultdiag,permapsdiag,statsdiag);

%% Save cfg file:
mvpalab_savecfg(cfg);