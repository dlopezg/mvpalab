clear all
clc

load mask

mask_indexes = find(mask);
mask_dimensions = size(mask);
[x,y,z] = ind2sub(mask_dimensions,mask_indexes);
mask_coordinates = [x,y,z];

% figure
% scatter3(x,y,z,1,'filled');

%% Generate searchlight sphere:
radius = 4;

reference_voxel = round(mask_dimensions./2);
searchlight_volume = zeros(mask_dimensions);
searchlight_volume(...
    reference_voxel(1)-radius:reference_voxel(1)+radius,...
    reference_voxel(2)-radius:reference_voxel(2)+radius,...
    reference_voxel(3)-radius:reference_voxel(3)+radius) = 1;

% Get indexes for the cube:
[x,y,z] = ind2sub(mask_dimensions,find(searchlight_volume));
cube_coordinates = [x y z];

% Generate sphere of radius r:
sphere = [];
for i = 1 : size(cube_coordinates,1)
    point = cube_coordinates(i,:);
    distance = norm(point-reference_voxel);
    
    if distance <= radius
        sphere = [sphere; cube_coordinates(i,:)];
    end
end
% hold on
% scatter3(sphere(:,1),sphere(:,2),sphere(:,3),10,'filled','r');
% Sphere in (0,0,0)
sphere = sphere - reference_voxel;
% scatter3(sphere(:,1),sphere(:,2),sphere(:,3),10,'filled','r');
%% Plot searchlight cube:

figure(1)
scatter3(1,1,1,10,'filled','k');
hold on
xlim([0,mask_dimensions(1)])
ylim([0,mask_dimensions(2)])
zlim([0,mask_dimensions(3)])

hist = [];
ploting_points = (1:900:length(mask_coordinates));
tic
for i = 1 : length(mask_coordinates)
    
    voxel_coordinates = mask_coordinates(i,:);
    hist = [hist; voxel_coordinates];
    sphere_ = sphere + voxel_coordinates;
    try
        ind = sub2ind(mask_dimensions,sphere_(:,1),sphere_(:,2),sphere_(:,3));
    catch
        % Check first dimension:
        sphere_ = mvpalab_checkboundaries(sphere_,mask_dimensions);
        ind = sub2ind(mask_dimensions,sphere_(:,1),sphere_(:,2),sphere_(:,3));
    end
    
    pattern1 = mask(ind);
    pattern2 = mask(ind);
    pattern3 = mask(ind);
    pattern4 = mask(ind);
    pattern5 = mask(ind);
    pattern6 = mask(ind);
    pattern7 = mask(ind);
    pattern8 = mask(ind);
    
    if 0
        if any(i == ploting_points) || i == length(mask_coordinates)
            s = plot3(sphere_(:,1),sphere_(:,2),sphere_(:,3),'o','Color','#A2142F','MarkerSize',5,'MarkerFaceColor','#A2142F');
            
            % Plot 3D mask and projections:
            d = plot3(hist(:,1),hist(:,2),hist(:,3),'o','Color','k','MarkerSize',1,'MarkerFaceColor','k');
            
            p1 = plot3(mask_dimensions(1)*ones(length(hist),1),hist(:,2),hist(:,3),'o','Color','#4DBEEE','MarkerSize',3,'MarkerFaceColor','#4DBEEE');
            p2 = plot3(hist(:,1),mask_dimensions(2)*ones(length(hist),1),hist(:,3),'o','Color','#4DBEEE','MarkerSize',3,'MarkerFaceColor','#4DBEEE');
            p3 = plot3(hist(:,1),hist(:,2),0*ones(length(hist),1),'o','Color','#4DBEEE','MarkerSize',3,'MarkerFaceColor','#4DBEEE');
            %
            drawnow
            
            if ~(i == length(mask_coordinates))
                delete([s;d;p1;p2;p3]);
            end
            
        end
    end
    
end
toc

function sphere = mvpalab_checkboundaries (sphere,mask_dimensions)
idxs_x = find(sphere(:,1)<1|sphere(:,1)>mask_dimensions(1))';
idxs_y = find(sphere(:,2)<1|sphere(:,2)>mask_dimensions(2))';
idxs_z = find(sphere(:,3)<1|sphere(:,3)>mask_dimensions(3))';

idxs = horzcat(idxs_x,idxs_y,idxs_z);
sphere(idxs,:,:) = [];
end



