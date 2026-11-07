function volume = mvpalab_load_volumes(path)
%% MVPALAB_LOAD_VOLUMES
%
%  This function loads a mask or region of interest file
%  (mvpalab_read_nifti) and finds its voxels.
%
%%  INPUT:
%
%  - {string} - path:
%    Path of the NIfTI file.
%
%%  OUTPUT:
%
%  - {struct} - volume:
%    Volume with the fields of mvpalab_read_nifti (data, dim and fname),
%    idxs (the indexes of the nonzero elements of data) and coor (their
%    coordinates [voxels x 3]).

volume = mvpalab_read_nifti(path);
volume.idxs = find(volume.data);
[x,y,z] = ind2sub(volume.dim,volume.idxs);
volume.coor = [x,y,z];

end

