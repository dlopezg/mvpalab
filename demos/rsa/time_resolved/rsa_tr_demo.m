%% MVPAlab TOOLBOX - (rsa_tr_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% Initialize project and run configuration file:

cfg = mvpalab_init();
run cfg_file;

cfg.classmodel.parcomp = 0;

%% Load data, generate conditions and feature extraction:

[cfg,~,data] = mvpalab_import(cfg);

%% Compute the time-resolved representational similarity analysis:

[res,stats,cfg] = mvpalab_rsa_time(cfg,data);

%% Save cfg file:

mvpalab_savecfg(cfg);

%% Plot the results:

run plots/rsa_time_resolved.m;
run plots/rdm_time_resolved.m;
