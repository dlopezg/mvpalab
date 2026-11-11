%% MVPAlab TOOLBOX - (fusion_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------
clear; clc

%% Initialize project and run configuration file:

cfg = mvpalab_init();
run cfg_file;

%% Compute fusion

% With cfg.stats.flag it also computes the null maps and the
% permutation test:
[res,cfg,stats,nullmaps] = mvpalab_fusion(cfg,meeg_rdms,fmri_rdms);

%% Plot the results:

run fusion_plot; 
