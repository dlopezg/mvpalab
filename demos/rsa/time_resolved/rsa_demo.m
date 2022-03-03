%% MVPAlab TOOLBOX - (rsa_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% Initialize project and run configuration file:

cfg = mvpalab_init();
run cfg_file;

%% Load data, generate conditions and feature extraction:

[cfg,data,fv] = mvpalab_import(cfg);

%% Compute RSA analysis:

[result,stats,cfg] = mvpalab_rsa(cfg,fv);

%% Plot the results:

% run rsa_plot;

%% Save cfg file:

mvpalab_savecfg(cfg);