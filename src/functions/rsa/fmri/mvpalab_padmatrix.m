function padded_volume = mvpalab_padmatrix(r,volume)
%% MVPALAB_PADMATRIX
%
%  This function adds r NaN voxels at both sides of each dimension of a
%  volume. MATLAB converts NaN to 0 when data is of an integer type.
%
%%  INPUT:
%
%  - {int} - r:
%    Number of voxels added at each side (cfg.sl.radius in
%    mvpalab_padvolumes).
%
%  - {struct} - volume:
%    Volume with the fields data, dim and fname (see mvpalab_read_nifti).
%
%%  OUTPUT:
%
%  - {struct} - padded_volume:
%    Padded volume [dim + 2r] with the fields dim, fname, data, idxs (the
%    indexes of the nonzero elements of data, which include the NaN
%    voxels) and coor (their coordinates [voxels x 3]).

%% First dimension:
pad = NaN(r,volume.dim(2),volume.dim(3));
padded = cat(1,pad,volume.data);
padded = cat(1,padded,pad);

%% Second dimension:
pad = NaN(volume.dim(1)+r*2,volume.dim(2),r);
padded = cat(3,pad,padded);
padded = cat(3,padded,pad);

%% Thrid dimension:
pad = NaN(volume.dim(1)+r*2,r,volume.dim(3)+r*2);
padded = cat(2,pad,padded);
padded = cat(2,padded,pad);

%% Update volume info:
padded_volume.dim = size(padded);
padded_volume.fname = volume.fname;
padded_volume.data = padded;
padded_volume.idxs = find(padded);
[x,y,z] = ind2sub(padded_volume.dim,padded_volume.idxs);
padded_volume.coor = [x,y,z];
end

