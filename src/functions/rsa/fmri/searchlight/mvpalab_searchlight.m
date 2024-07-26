function [results,stats,cfg] = mvpalab_searchlight(cfg,masks,volumes)
dist = cfg.rsa.distance;

for sub = 1 : size(volumes, 2)

    disp(sub)

    %% Get subject name:
    % subject name should be sl_subject_sub where sub is the variable
    subject_name = ['sl_sub_' num2str(sub)];

    disp(subject_name)

    mask = masks{sub};
    data = volumes{sub};

    %% Pad volumes:
    mask_ = mvpalab_padvolumes(cfg,mask);
    data_ = mvpalab_padvolumes(cfg,data);
    
    %% Generate searchlight sphere:
    sphere = mvpalab_sphere(cfg,mask_);
    
    %% Timestamp
    tic

    voxels_coordinates = {};
    
    %% Iterate over mask voxels:
    for voxel = 1 : length(mask_.coor)
        %disp(voxel)
        %% Center the sphere at the current voxel:
        voxel_coordinates = mask_.coor(voxel,:);
        sphere_ = sphere + voxel_coordinates;

        % save the voxel coordinates for each voxel in the correct order
        voxels_coordinates{voxel} = voxel_coordinates;
        
        %% Get sphere indexes:
        ind = sub2ind(mask_.dim,sphere_(:,1),sphere_(:,2),sphere_(:,3));
    
        % call func combine runs first and do selection here (readability)
    
        %% Select data inside the sphere and the mask:
        idx = 1;
        for i = 1 : size(data_,1)
            for j = 1 : size(data_,2)
                selection = data_{i,j}.data(ind);
                data_to_corr(idx,:) = selection(~isnan(selection));
                idx = idx + 1;
            end
        end
    
    
        % compute rdms
        rdm = mvpalab_computerdm(cfg,data_to_corr);
    
        % merge runs
        rdm = mvpalab_mergerunsrdm(cfg,data_,rdm);
    
        rdms(:,:,voxel) = rdm;
    
        clear data_to_corr
    end

    %% Timestamp
    toc
    
    %% Save RSA data
    results.(dist).(subject_name).rdms = rdms;
    results.(dist).(subject_name).voxel_coordinates = voxels_coordinates;

    %results{sub} = rdms;
    stats = [];
end

mvpalab_save(cfg,results,'res');


end


function sphere = mvpalab_checkboundaries(sphere,mask_dim)
idxs_x = find(sphere(:,1)<1|sphere(:,1)>mask_dim(1))';
idxs_y = find(sphere(:,2)<1|sphere(:,2)>mask_dim(2))';
idxs_z = find(sphere(:,3)<1|sphere(:,3)>mask_dim(3))';

idxs = horzcat(idxs_x,idxs_y,idxs_z);
sphere(idxs,:,:) = [];
end



