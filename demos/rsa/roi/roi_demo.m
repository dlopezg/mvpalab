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

%% Subject loop:

for roi = 1 : length(cfg.rsa.roi)
    for sub = 1 : length(cfg.rsa.subjects)
        
        % 1. Initialization:
        
        subject_folder = fullfile(cfg.rsa.subjects{sub},cfg.rsa.betafolder);
        conditions = cfg.rsa.conditions;
        
        [~,roi_id,~] = fileparts(cfg.rsa.roi{roi});
        roi_file = fullfile(cfg.rsa.subjects{sub},cfg.rsa.roi_folder,cfg.rsa.roi{roi});
        
        % 2. Load beta files for each subject:
        data{sub} = mvpalab_load_betas(subject_folder,conditions);
        
        % 3. Load ROIs for each subject:
        mask{sub} = mvpalab_load_volumes(roi_file);
        
        % Extract RDM for each roi and subject:
        rdm{sub} = mvpalab_rdm_roi(cfg,data{sub},mask{sub});
        
    end
    
    result.rdms.(cfg.rsa.distance).(roi_id) = rdm;
    result.rois.(roi_id) = mask;
    
end

mvpalab_save(cfg,result,'res');
