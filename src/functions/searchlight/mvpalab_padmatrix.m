function padded_volume = mvpalab_padmatrix(r,volume)
%% MVPALAB_PADMATRIX

%   Detailed explanation goes here

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

