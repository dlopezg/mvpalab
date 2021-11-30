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

[cfg,diffMap,stats] = mvpalab_sfilter(cfg);

%% Save cfg file:

mvpalab_savecfg(cfg);

%% Plot the results:

run sf_plot;
