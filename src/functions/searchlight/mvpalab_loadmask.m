function mask = mvpalab_loadmask(cfg)
%% MVPALAB_LOADMASK 
%
%  This function load the specified mask or ROI file for the searchlight
%  analysis.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Description: Configuration structure.
%
%%  OUTPUT:
%
%  - {struct} - data:
%    Description: Mask file containing the following fields:
%       mask.data:  [3D-matrix] containing the mask voxels.
%       mask.dim:   [vector]    containing the size of the mask.
%       mask.fname: [string]    containing the path to the mask file.
%
%%

mask = mvpalab_readnifti(cfg.study.maskFile);
mask.idxs = find(mask.data);
[x,y,z] = ind2sub(mask.dim,mask.idxs);
mask.coor = [x,y,z];

end

