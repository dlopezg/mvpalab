function [cfg,results] = mvpalab_fusion_meaneeg(cfg,fmri_rois,eeg_rdms)

%% Fusion: mean EEG - FMRI:

% Mean EEG rdm:
eeg_rdm = mvpalab_meanrdm(eeg_rdms);
ntp = size(eeg_rdm,3);

% Vectorize mean matrices:
eeg_rdm = mvpalab_vectorizerdm(cfg,eeg_rdm);

% For each roi:
roi_names = fieldnames(fmri_rois);

for roi = 1 :length(roi_names)
    
    % ROI name:
    roi_name = roi_names{roi};
    
    % Select RDM matrices for each ROI:
    fmri_rdms = fmri_rois.(roi_name);
    
    % Compute fusion:
    for sub = 1 : length(fmri_rdms)
        
        % Subject rdm:
        fmri_rdm = fmri_rdms{sub};
        
        % Vectorize RDM for each FMRI subject:
        fmri_rdm = mvpalab_vectorizerdm(cfg,fmri_rdm);
        
        % Repeat mean matrices for each timepoint:
        fmri_rdm = repmat(fmri_rdm,[ntp 1 1]);
        
        % Compute correlation:
        results.res.(roi_name)(1,:,sub) = mvpalab_computecorr(...
            cfg,fmri_rdm,eeg_rdm,false);
        
        % Compute permutated maps if needed:
        if cfg.stats.flag
            results.permaps.(roi_name)(1,:,sub,:) = mvpalab_computecorr(...
                cfg,fmri_rdm,eeg_rdm,true);
        end
        
    end
end

end

