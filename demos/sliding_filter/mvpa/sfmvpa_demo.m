%% MVPAlab TOOLBOX - (sfmvpa_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------
 clear; clc; 
 
%% Initialize project and run configuration file:

cfg = mvpalab_init();
run cfg_file;

%% Load data, generate conditions and feature extraction:

cfg = mvpalab_import(cfg);

%% Compute sliding filter analysis:

% With cfg.stats.flag it also computes the null maps and the
% permutation test:
[diffMap,cfg,stats,nullmaps] = mvpalab_sfilter(cfg);

%% Plot the results:

run sf_plot;
