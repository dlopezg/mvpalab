%% MVPAlab TOOLBOX - (mvcc_demo.m)
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

%% Compute MVCC analysis:
[result,cfg] = mvpalab_decoding(cfg,fv);

%% Compute permutation maps and run statistical analysis:

[nullmaps,cfg] = mvpalab_nullmaps(cfg,fv,result);
stats = mvpalab_permtest(cfg,result,nullmaps);

%% Plot the results:

run mvcc_plot;
