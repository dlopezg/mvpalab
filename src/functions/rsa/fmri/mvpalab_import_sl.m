function [volumes,masks,cfg] = mvpalab_import_sl(cfg)
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
    
    sub_folder = fullfile(cfg.rsa.subjects{sub},cfg.study.SPMFolder);
    conditions = cfg.rsa.conditions;
    volumes{sub} = mvpalab_load_betas(sub_folder,conditions);
    sub_mask = fullfile(cfg.rsa.subjects{sub},cfg.study.maskFile);
    masks{sub} = mvpalab_load_volumes(sub_mask);
end

