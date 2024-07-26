function [cfg, results] = mvpalab_fusion_meansearchlight(cfg, fmri_searchlight, eeg_rdms)
% For each voxel in the searchlight data:

% Get the dimensions of the searchlight data
[rdm_size, ~, num_voxels] = size(fmri_searchlight);

% Initialize results structure
results.res = struct();
if cfg.stats.flag
    results.permaps = struct();
end

for voxel = 1:num_voxels
    disp("Voxel :")
    disp(voxel)
    
    % Extract the RDM for the current voxel
    voxel_rdm = fmri_searchlight(:, :, voxel);
    
    % Convert the voxel_rdm to a cell array if it is not already
    if ~iscell(voxel_rdm)
        voxel_rdm = {voxel_rdm};
    end
    
    % Compute the mean RDM matrix for the current voxel
    mean_rdm = mvpalab_meanrdm(voxel_rdm);
    
    % Vectorize mean matrices
    vmean_rdm = mvpalab_vectorizerdm(cfg, mean_rdm);
    
    % Compute fusion
    for sub = 1:length(eeg_rdms)
        
        % Subject RDM
        eeg_rdm = eeg_rdms{sub};
        ntp = size(eeg_rdm, 3);
        
        % Vectorize RDM for each EEG subject
        eeg_rdm = mvpalab_vectorizerdm(cfg, eeg_rdm);
        
        % Repeat mean matrices for each timepoint
        vmean_rdm_ = repmat(vmean_rdm, [ntp 1 1]);
        
        % Compute correlation
        results.res.(['voxel_' num2str(voxel)])(1, :, sub) = mvpalab_computecorr(...
            cfg, eeg_rdm, vmean_rdm_, false);
        
        % Compute permutated maps if needed
        if cfg.stats.flag
            results.permaps.(['voxel_' num2str(voxel)])(1, :, sub, :) = mvpalab_computecorr(...
                cfg, eeg_rdm, vmean_rdm_, true);
        end
        
    end
end

end