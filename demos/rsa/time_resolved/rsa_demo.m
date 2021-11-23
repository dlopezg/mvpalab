%% MVPAlab TOOLBOX - (mvpa_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% Initialize project and run configuration file:

cfg = mvpalab_init();
run cfg_file_advanced;

%% Load data, generate conditions and feature extraction:

[cfg,data,fv] = mvpalab_import(cfg);

%% Compute RSA analysis:

% [result,cfg] = mvpalab_rsa(cfg,fv);

%% Compute permutation maps and run statistical analysis:

% [permaps,cfg] = mvpalab_permaps(cfg,fv);
% stats = mvpalab_permtest(cfg,result,permaps);

%% Save cfg file:

% mvpalab_savecfg(cfg);
