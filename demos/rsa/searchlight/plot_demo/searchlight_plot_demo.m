clear all
clc
%% Initialization:
graph = mvpalab_plotinit();

% Colors:
colormap = 'mvpalab';
graph.colorSch = graph.colors.(colormap);
graph.colorMap = graph.grads.(colormap);
sphereColor = graph.colorSch{11};

speed = 1;
start = 190000;
hist = [];
cfg.sl.radius = 4;
mask = mvpalab_load_volumes('mask.nii');
ploting_points = (start:speed:length(mask.coor));

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
        s = plot3(sphere_(:,1),sphere_(:,2),sphere_(:,3),'o','Color',sphereColor,'MarkerSize',5,'MarkerFaceColor',sphereColor);
        
        % Plot 3D mask_ and projections:
        d = plot3(hist(:,1),hist(:,2),hist(:,3),'o','Color','k','MarkerSize',.5,'MarkerFaceColor','k');
        
        % Completed projections
        px = plot3(mask_.dim(1)*ones(length(hist),1),hist(:,2),hist(:,3),'o','Color','#BBBBBB','MarkerSize',3,'MarkerFaceColor','#BBBBBB');
        py = plot3(hist(:,1),mask_.dim(2)*ones(length(hist),1),hist(:,3),'o','Color','#BBBBBB','MarkerSize',3,'MarkerFaceColor','#BBBBBB');
        pz = plot3(hist(:,1),hist(:,2),0*ones(length(hist),1),'o','Color','#BBBBBB','MarkerSize',3,'MarkerFaceColor','#BBBBBB');
        
        % Sphere projections:
        spx = plot3(mask_.dim(1)*ones(length(sphere_),1),sphere_(:,2),sphere_(:,3),'o','Color',sphereColor,'MarkerSize',3,'MarkerFaceColor',sphereColor);
        spy = plot3(sphere_(:,1),mask_.dim(2)*ones(length(sphere_),1),sphere_(:,3),'o','Color',sphereColor,'MarkerSize',3,'MarkerFaceColor',sphereColor);
        spz = plot3(sphere_(:,1),sphere_(:,2),0*ones(length(sphere_),1),'o','Color',sphereColor,'MarkerSize',3,'MarkerFaceColor',sphereColor);
        
        drawnow
        
        if ~(voxel == length(mask_.coor))
            delete([s;d;px;py;pz;spx;spy;spz]);
        end
    end
end

