function [result,stats,cfg] = mvpalab_searchlight(cfg,mask,data)
%% MVPALAB_SEARCHLIGHT
%
%  This function computes a searchlight analysis of the fMRI betas of one
%  subject. The mask and the betas are padded with cfg.sl.radius NaN
%  voxels (mvpalab_padvolumes), and a sphere of radius cfg.sl.radius
%  (mvpalab_sphere) is centered at each voxel in the idxs of the padded
%  mask. At each voxel, the correlation matrix (corrcoef) between the
%  betas is computed with the voxels inside the sphere, without the voxels
%  with NaN values.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - mask:
%    Mask of the analysis (see mvpalab_load_volumes).
%
%  - {cell array} - data:
%    Betas [conditions x runs] (see mvpalab_load_betas).
%
%%  OUTPUT:
%
%  - {matrix} - result:
%    Correlation matrix at each voxel of the mask [betas x betas x
%    voxels], with betas = conditions x runs ordered condition by
%    condition.
%
%  - {matrix} - stats:
%    Empty matrix.
%
%  - {struct} - cfg:
%    Configuration structure, without changes.

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
