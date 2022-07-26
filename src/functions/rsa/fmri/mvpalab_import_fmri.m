function [cfg,data,mask] = mvpalab_import_fmri(cfg)
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

%% Load nifti mask:
if isfield(cfg.study,'maskFile')
    mask = mvpalab_load_volumes(cfg.study.maskFile);
end

%% Load condition data:
data = mvpalab_load_betas(cfg.study.SPMFolder,cfg.rsa.conditions);

%% Masked data:
% masked_data = mvpalab_maskbetas(mask,data);

%% Normaliza data:

end

