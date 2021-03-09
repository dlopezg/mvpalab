%% MVPAlab TOOLBOX - (mvpa_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------
clear; clc;

%% Initialize project and run configuration file:

cfg = mvpalab_init();
run cfg_file; % cfg_file_advanced for advanced configuration.

%% Load data, generate conditions and feature extraction:

[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVPA analysis:

[result,cfg] = mvpalab_mvcc(cfg,fv);

%% Compute permutation maps and run statistical analysis:

[permaps,cfg] = mvpalab_cpermaps(cfg,fv);
stats = mvpalab_permtest(cfg,result,permaps);

%% Save cfg file:

mvpalab_savecfg(cfg);

%% Plot the results:

% run mvcc_plot;
