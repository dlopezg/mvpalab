function sphere = mvpalab_sphere(cfg,mask)
%% MVPALAB_SPHERE
%
%   Detailed explanation goes here

%% Initialization:
sphere = [];
r = cfg.sl.radius;
reference_voxel = round(mask.dim./2);
searchlight_volume = zeros(mask.dim);

%% Generate cube:
searchlight_volume(...
    reference_voxel(1)-r:reference_voxel(1)+r,...
    reference_voxel(2)-r:reference_voxel(2)+r,...
    reference_voxel(3)-r:reference_voxel(3)+r) = 1;

%% Get cube's indexes and coordinates:
[x,y,z] = ind2sub(mask.dim,find(searchlight_volume));
cube_coordinates = [x y z];

%% Generate sphere of radius r:
for i = 1 : size(cube_coordinates,1)
    if norm(cube_coordinates(i,:)-reference_voxel) < r
        sphere = [sphere; cube_coordinates(i,:)];
    end
end

%% Center the sphere at (0,0,0):
sphere = sphere - reference_voxel;

end

