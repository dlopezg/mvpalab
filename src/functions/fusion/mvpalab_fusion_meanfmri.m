function [cfg,results] = mvpalab_fusion_meanfmri(cfg,fmri_rois,eeg_rdms)
% For each roi:
    roi_names = fieldnames(fmri_rois);
    
    for roi = 1 :length(roi_names)
        
        % ROI name:
        roi_name = roi_names{roi};
        
        % Compute the mean RDM matrix for each ROI:
        mean_rdm = mvpalab_meanrdm(fmri_rois.(roi_name));
        
        % Vectorize mean matrices:
        vmean_rdm = mvpalab_vectorizerdm(cfg,mean_rdm);
        
        % Compute fusion:
        for sub = 1 : length(eeg_rdms)
            
            % Subject rdm:
            eeg_rdm = eeg_rdms{sub};
            ntp = size(eeg_rdm,3);
            
            % Vectorize RDM for each EEG subject:
            eeg_rdm = mvpalab_vectorizerdm(cfg,eeg_rdm);
            
            % Repeat mean matrices for each timepoint:
            vmean_rdm_ = repmat(vmean_rdm,[ntp 1 1]);
            
            % Compute correlation:
            results.res.(roi_name)(1,:,sub) = mvpalab_computecorr(...
                cfg,eeg_rdm,vmean_rdm_,false);
            
            % Compute permutated maps if needed:
            if cfg.stats.flag
                results.permaps.(roi_name)(1,:,sub,:) = mvpalab_computecorr(...
                    cfg,eeg_rdm,vmean_rdm_,true);
            end
            
        end
    end
    
end

