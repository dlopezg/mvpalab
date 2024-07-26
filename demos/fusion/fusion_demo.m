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

[cfg,res,permaps,stats] = mvpalab_fusion(cfg,meeg_rdms,fmri_rdms, searchlight_rdms);

%% Plot the results:
if strcmp(cfg.fusion.mode,'searchlight')
    run fusion_plot_sl; 
else
    run fusion_plot; 
end