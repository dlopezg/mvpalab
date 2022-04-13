function [cfg,mask,data] = mvpalab_importfmri(cfg)
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
mask = mvpalab_loadmask(cfg);

%% Load condition data:
data = mvpalab_loadbetas(cfg);

%% Masked data:
% masked_data = mvpalab_maskbetas(mask,data);

%% Normaliza data:

end

