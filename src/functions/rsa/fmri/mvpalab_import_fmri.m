function [volumes,masks,cfg] = mvpalab_import_fmri(cfg)
%% MVPALAB_IMPORTFMRI
%
%  This function import the required fmri data for the searchligth
%  analysis, including the mask, the specified betas for each condition.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Description: Configuration structure.
%
%%  OUTPUT:
%

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

