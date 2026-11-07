function [cfg,results] = mvpalab_fusion_meanfmri(cfg,fmri_rois,eeg_rdms)
%% MVPALAB_FUSION_MEANFMRI
%
%  This function computes the fusion in the 'mean-fmri' mode of
%  mvpalab_fusion: the mean RDM of the fMRI subjects in each region of
%  interest (mvpalab_meanrdm) is correlated with the RDM of each M/EEG
%  subject at each timepoint (mvpalab_computecorr).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - fmri_rois:
%    One field per region of interest, with a cell array that contains the
%    RDM of each fMRI subject [conditions x conditions].
%
%  - {cell array} - eeg_rdms:
%    RDM of each M/EEG subject [conditions x conditions x timepoints].
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Configuration structure, without changes.
%
%  - {struct} - results:
%    - res.(region): Correlations [1 x timepoints x M/EEG subjects].
%    - permaps.(region): Permuted maps [1 x timepoints x M/EEG subjects x
%      permutations], only with cfg.stats.flag and without
%      cfg.stats.signflip.

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
            if cfg.stats.flag && ~cfg.stats.signflip
                results.permaps.(roi_name)(1,:,sub,:) = mvpalab_computecorr(...
                    cfg,eeg_rdm,vmean_rdm_,true);
            end
            
        end
    end
    
end

