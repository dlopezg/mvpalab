clear all
clc
%% Initialization:
speed = 500;
hist = [];
cfg.study.maskFile = 'mask.nii';
cfg.sl.radius = 4;
mask = mvpalab_loadmask(cfg);
ploting_points = (1:speed:length(mask.coor));

%% Pad volumes:
mask_ = mvpalab_padvolumes(cfg,mask);

%% Generate searchlight sphere:
sphere = mvpalab_sphere(cfg,mask_);

%% Initialize plot:
figure(1)
pause
scatter3(1,1,1,10,'filled','k');
hold on
xlim([0,mask_.dim(1)])
ylim([0,mask_.dim(2)])
zlim([0,mask_.dim(3)])

%% Iterate over mask voxels:
for voxel = 1 : length(mask_.coor)
    %% Center the sphere at the current voxel:
    voxel_coordinates = mask_.coor(voxel,:);
    sphere_ = sphere + voxel_coordinates;
    
    %% Get sphere indexes:
    ind = sub2ind(mask_.dim,sphere_(:,1),sphere_(:,2),sphere_(:,3));
    
    %% Searchlight representation:
    hist = [hist; voxel_coordinates];
    if any(voxel == ploting_points) || voxel == length(mask_.coor)
        s = plot3(sphere_(:,1),sphere_(:,2),sphere_(:,3),'o','Color','#A2142F','MarkerSize',5,'MarkerFaceColor','#A2142F');
        
        % Plot 3D mask_ and projections:
        d = plot3(hist(:,1),hist(:,2),hist(:,3),'o','Color','k','MarkerSize',.5,'MarkerFaceColor','k');
        
        % Completed projections
        px = plot3(mask_.dim(1)*ones(length(hist),1),hist(:,2),hist(:,3),'o','Color','#4DBEEE','MarkerSize',3,'MarkerFaceColor','#4DBEEE');
        py = plot3(hist(:,1),mask_.dim(2)*ones(length(hist),1),hist(:,3),'o','Color','#4DBEEE','MarkerSize',3,'MarkerFaceColor','#4DBEEE');
        pz = plot3(hist(:,1),hist(:,2),0*ones(length(hist),1),'o','Color','#4DBEEE','MarkerSize',3,'MarkerFaceColor','#4DBEEE');
        
        % Sphere projections:
        spx = plot3(mask_.dim(1)*ones(length(sphere_),1),sphere_(:,2),sphere_(:,3),'o','Color','#EDB120','MarkerSize',3,'MarkerFaceColor','#EDB120');
        spy = plot3(sphere_(:,1),mask_.dim(2)*ones(length(sphere_),1),sphere_(:,3),'o','Color','#EDB120','MarkerSize',3,'MarkerFaceColor','#EDB120');
        spz = plot3(sphere_(:,1),sphere_(:,2),0*ones(length(sphere_),1),'o','Color','#EDB120','MarkerSize',3,'MarkerFaceColor','#EDB120');
        
        drawnow
        
        if ~(voxel == length(mask_.coor))
            delete([s;d;px;py;pz;spx;spy;spz]);
        end
    end
end

