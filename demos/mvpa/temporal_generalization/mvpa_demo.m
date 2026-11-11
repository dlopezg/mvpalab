%% MVPAlab TOOLBOX - (mvpa_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

clear; clc;

%% Initialize project and run configuration file:

cfg = mvpalab_init();
run cfg_file;

%% Load data, generate conditions and feature extraction:

[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVPA analysis:

% With cfg.stats.flag it also computes the null maps and the
% permutation test:
[result,cfg,stats,nullmaps] = mvpalab_decoding(cfg,fv);

%% Plot the results:

run mvpa_plot;
