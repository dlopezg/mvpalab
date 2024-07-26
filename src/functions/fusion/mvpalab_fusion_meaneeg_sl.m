function [cfg, results] = mvpalab_fusion_meaneeg_sl(cfg, fmri_searchlight, eeg_rdms)

%% Fusion: mean EEG - FMRI:

% Mean EEG RDM:
eeg_rdm = mvpalab_meanrdm(eeg_rdms);
ntp = size(eeg_rdm, 3);

% Vectorize mean matrices:
eeg_rdm = mvpalab_vectorizerdm(cfg, eeg_rdm);

% Initialize results structure
results.res = struct();
if cfg.stats.flag
    results.permaps = struct();
end

for sub = 1 : length(fmri_searchlight)
    sub_rdm = fmri_searchlight{sub};

    % Get the dimensions of the searchlight data
    [rdm_size, ~, num_voxels] = size(sub_rdm);

     % make matrix smaller for testing reasons
    % sub_rdm = sub_rdm(1:rdm_size, 1:rdm_size, 1:10000);
    % num_voxels = 10000;

    % For each voxel in the searchlight data:
    for voxel = 1: num_voxels

        voxel_rdm = sub_rdm(:, :, voxel);

        voxel_rdm = mvpalab_vectorizerdm(cfg, voxel_rdm);

        voxel_rdm = repmat(voxel_rdm, [ntp 1 1]);

        results.res.(['sl_sub' num2str(sub)])(1, :, voxel) = mvpalab_computecorr(cfg, voxel_rdm, eeg_rdm, false);

        if cfg.stats.flag
            results.permaps.(['sl_sub' num2str(sub)])(1, :, voxel, :) = mvpalab_computecorr(cfg, voxel_rdm, eeg_rdm, true);
        end
    end

end

end