function [volumes,masks,cfg] = mvpalab_import_fmri(cfg)
%% MVPALAB_IMPORT_FMRI
%
%  This function imports the fMRI data of each subject in
%  cfg.rsa.subjects:
%
%  - The betas of the conditions in cfg.rsa.conditions, from the folder
%    cfg.rsa.betafolder of the subject (mvpalab_load_betas).
%  - The masks of the regions of interest in cfg.rsa.roi, from the folder
%    cfg.rsa.roi_folder of the subject (mvpalab_load_volumes). Each
%    region is named after its file without the extension.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {cell array} - volumes:
%    Betas of each subject, each one a cell array [conditions x runs] (see
%    mvpalab_load_betas).
%
%  - {cell array} - masks:
%    Regions of interest of each subject, each one a struct with one field
%    per region in the order of cfg.rsa.roi (see mvpalab_load_volumes).
%
%  - {struct} - cfg:
%    Configuration structure, without changes.

%% Subjects loop:
%  Iterate along subjects:
for sub = 1 : length(cfg.rsa.subjects)
    %% 1. Load beta files:
    %  Load beta files for each condition and subject:
    
    sub_folder = fullfile(cfg.rsa.subjects{sub},cfg.rsa.betafolder);
    conditions = cfg.rsa.conditions;
    volumes{sub} = mvpalab_load_betas(sub_folder,conditions);
    
    %% ROIs loop:
    %  Iterate along brain regions:
    for roi = 1 : length(cfg.rsa.roi)
        %% 2. Load ROI masks:
        %  Load the mask file for each brain region:
        
        [~,roi_id,~] = fileparts(cfg.rsa.roi{roi});
        roi_file = fullfile(cfg.rsa.subjects{sub},cfg.rsa.roi_folder,...
            cfg.rsa.roi{roi});
        masks{sub}.(roi_id) = mvpalab_load_volumes(roi_file);
    end
end
end

