%% MVPAlab TOOLBOX - (roi_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

clear all
clc

%% Initialize project and run configuration file:

cfg = mvpalab_init();
run cfg_file;

%% Import volumes:

[volumes,masks,cfg] = mvpalab_import_fmri(cfg);

%% Compute the Representational similarity analysis:

[res,stats,cfg] = mvpalab_rsa_roi(cfg,volumes,masks);

%% Plot the results:

% run rsa_plot;

%% Save cfg file:

mvpalab_savecfg(cfg);
