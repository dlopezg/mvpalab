clear all
clc

load mask

mask_indexes = find(mask);
mask_dimensions = size(mask);
[x,y,z] = ind2sub(mask_dimensions,mask_indexes);
mask_coordinates = [x,y,z];

figure
scatter3(x,y,z,1,'filled');

%% Generate searchlight sphere:
radius = 4;

reference_voxel = round(mask_dimensions./2);
searchlight_volume = zeros(mask_dimensions);

% Aquí tenemos que jugar con el de referencia para que el cubo entre dentro
% del volumen, no hay otra...

% Empezamos por el principio:
selected_voxel = [1,1,1];

if selected_voxel(1) - radius < 1
    rx = selected_voxel(1) - 1;
else
    rx = radius; 
end

if selected_voxel(1) + radius > mask_dimensions(1)
    rx_ = mask_dimensions(1) - selected_voxel(1);
else
    rx_ = radius; 
end

if selected_voxel(2) - radius < 1
    ry = selected_voxel(2) - 1;
else
    ry = radius; 
end

if selected_voxel(2) + radius > mask_dimensions(2)
    ry_ = mask_dimensions(2) - selected_voxel(2);
else
    ry_ = radius; 
end

if selected_voxel(3) - radius < 1
    rz = selected_voxel(3) - 1;
else
    rz = radius; 
end

if selected_voxel(3) + radius > mask_dimensions(3)
    rz_ = mask_dimensions(3) - selected_voxel(3);
else
    rz_ = radius; 
end

searchlight_volume(...
    selected_voxel(1)-rx:selected_voxel(1)+rx_,...
    selected_voxel(2)-ry:selected_voxel(2)+ry_,...
    selected_voxel(3)-rz:selected_voxel(3)+rz_) = 1;

% Get indexes for the cube:
[x,y,z] = ind2sub(mask_dimensions,find(searchlight_volume));
cube_coordinates = [x y z];

% Generate sphere of radius r:
sphere = [];
for i = 1 : size(cube_coordinates,1)
    
    point = cube_coordinates(i,:);
    distance = norm(point-selected_voxel);
    
    if distance <= radius
        sphere = [sphere; cube_coordinates(i,:)];
    end
end
hold on
scatter3(sphere(:,1),sphere(:,2),sphere(:,3),10,'filled','r');
% Sphere in (0,0,0)
sphere = sphere - selected_voxel;
scatter3(sphere(:,1),sphere(:,2),sphere(:,3),10,'filled','r');
%% Plot searchlight cube:
hold on 

tic
for i = 1 : length(mask_coordinates)
    voxel_coordinates = mask_coordinates(i,:);
    sphere_ = sphere + voxel_coordinates;
    % scatter3(sphere_(:,1),sphere_(:,2),sphere_(:,3),10,'filled','r');
end
toc

% Hay que multiplicar el volumen del cubo por el volumen de la máscara en
% valores lógicos para obtener la intersección:
% Pero antes tengo que llevar la esfera al mismo espacio que la máscara.
searchlight_volume = logical(ones(mask_dimensions));

intersection = mask.*sphere;



