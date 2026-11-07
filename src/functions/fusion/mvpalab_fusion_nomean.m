function [cfg,results] = mvpalab_fusion_nomean(cfg,fmri_rois,eeg_rdms)
%% MVPALAB_FUSION_NOMEAN
%
%  This function computes the fusion in the 'no-mean' mode of
%  mvpalab_fusion: the RDM of each fMRI subject in each region of interest
%  is correlated with the RDM of each M/EEG subject at each timepoint
%  (mvpalab_computecorr). There is one observation per pair of subjects,
%  ordered by fMRI subject: first the first fMRI subject with each M/EEG
%  subject, then the second fMRI subject...
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
%    - res.(region): Correlations [1 x timepoints x pairs].
%    - permaps.(region): Permuted maps [1 x timepoints x pairs x
%      permutations], only with cfg.stats.flag and without
%      cfg.stats.signflip.

% Initialize:
ntp = size(eeg_rdms{1},3);

%%  Compute fusion:
%   For each roi:
roi_names = fieldnames(fmri_rois);

for roi = 1 :length(roi_names)
    
    % Initialize index:
    idx = 1;
    
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
        
        for sub_ = 1 : length(eeg_rdms)
            
            % Vectorize RDM for each EEG subject:
            eeg_rdm = mvpalab_vectorizerdm(cfg,eeg_rdms{sub_});
            
            % Compute correlation for each ROI:
            results.res.(roi_name)(1,:,idx) = mvpalab_computecorr(...
                cfg,eeg_rdm,fmri_rdm,false);
            
            % Compute permutated maps if needed:
            if cfg.stats.flag && ~cfg.stats.signflip
                results.permaps.(roi_name)(1,:,idx,:) = mvpalab_computecorr(...
                    cfg,eeg_rdm,fmri_rdm,true);
            end
            
            % Update subject index
            idx = idx + 1;
        end
    end
end


end

