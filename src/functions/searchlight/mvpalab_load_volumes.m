function volume = mvpalab_load_volumes(path)
%% MVPALAB_LOADVOLUME 
%
%  This function load the specified mask or ROI file for the RSA analysis.
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
%       volume.data:  [3D-matrix] containing the mask voxels.
%       volume.dim:   [vector]    containing the size of the mask.
%       volume.fname: [string]    containing the path to the mask file.
%
%%

volume = mvpalab_read_nifti(path);
volume.idxs = find(volume.data);
[x,y,z] = ind2sub(volume.dim,volume.idxs);
volume.coor = [x,y,z];

end

