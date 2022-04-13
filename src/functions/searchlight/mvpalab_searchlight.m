function [result,stats,cfg] = mvpalab_searchlight(cfg,mask,data)
%% Pad volumes:
mask_ = mvpalab_padvolumes(cfg,mask);
data_ = mvpalab_padvolumes(cfg,data);

%% Generate searchlight sphere:
sphere = mvpalab_sphere(cfg,mask_);

%% Timestamp
tic

%% Iterate over mask voxels:
for voxel = 1 : length(mask_.coor)
    %% Center the sphere at the current voxel:
    voxel_coordinates = mask_.coor(voxel,:);
    sphere_ = sphere + voxel_coordinates;
    
    %% Get sphere indexes:
    ind = sub2ind(mask_.dim,sphere_(:,1),sphere_(:,2),sphere_(:,3));

    %% Select data inside the sphere and the mask:
    idx = 1;
    for i = 1 : size(data_,1)
        for j = 1 : size(data_,2)
            selection = data_{i,j}.data(ind);
            data_to_coor(idx,:) = selection(~isnan(selection)); 
            idx = idx + 1;
        end
    end

    %% Extract RDMS:
    rdms(:,:,voxel) = corrcoef(data_to_coor');
    clear data_to_coor
end
%% Timestamp
toc

result = rdms;
stats = [];

end

function sphere = mvpalab_checkboundaries(sphere,mask_dim)
idxs_x = find(sphere(:,1)<1|sphere(:,1)>mask_dim(1))';
idxs_y = find(sphere(:,2)<1|sphere(:,2)>mask_dim(2))';
idxs_z = find(sphere(:,3)<1|sphere(:,3)>mask_dim(3))';

idxs = horzcat(idxs_x,idxs_y,idxs_z);
sphere(idxs,:,:) = [];
end



