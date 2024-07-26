%% MVPAlab TOOLBOX - (searchlight_demo.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% Initialize project and run configuration file:

cfg = mvpalab_init();
run cfg_file;

[volumes,masks,cfg] = mvpalab_import_sl(cfg);

%sub_folder = cfg.study.SPMFolder;
%conditions = cfg.rsa.conditions;
%data = mvpalab_load_betas(sub_folder,conditions);
%mask = mvpalab_load_volumes(cfg.study.maskFile);

%% Load mask and data:

% [cfg,data,mask] = mvpalab_import_fmri(cfg);

%% Compute searchlight analysis:

[results,stats,cfg] = mvpalab_searchlight(cfg,masks,volumes);

%% Plot the results:

% run rsa_plot;

%% Save cfg file:

mvpalab_savecfg(cfg);

fprintf('Done')