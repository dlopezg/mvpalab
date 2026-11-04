function [res,stats,cfg] = mvpalab_rsa_roi(cfg,volumes,masks)
%% Initialize
stats = struct();
mode = cfg.rsa.modality;
dist = cfg.rsa.distance;

%% Cross-validation is not supported yet:
%  The RDMs are computed between all the betas (conditions x runs) of each
%  subject, without cross-validation. Cross-validated distances
%  (cfg.rsa.nfolds > 1 or 'crossnobis') would require a leave-one-run-out
%  partition, which is not implemented for fMRI data.

if cfg.rsa.nfolds > 1 || strcmp(dist,'crossnobis')
    error(['Cross-validated RDMs (cfg.rsa.nfolds > 1 or ''crossnobis'') ' ...
        'are not supported for fMRI ROI analyses yet. Use ' ...
        'cfg.rsa.nfolds = 1.']);
end

%% Generate and vectorize the theoretical RD matrices:
%  Based on the previously designed models.
%  theo - [n_conditions x n_conditions x 1 x models]
%  vtheo - [1 x vectorized]

theo = mvpalab_gentrdms(cfg,cfg.rsa.tmodels);
vtheo = mvpalab_vectorizerdm(cfg,theo);
    
%% ROIs loop:
%  Iterate along brain regions:
for roi = 1 : length(cfg.rsa.roi)
    %% Subjects loop:
    %  Iterate along subjects:

    for sub = 1 : length(volumes)
    
        subject_rois = masks{sub};
        subject_rois_names = fieldnames(subject_rois);
        subject_betas = volumes{sub};

        subject_roi_name = subject_rois_names{roi};
        subject_roi = subject_rois.(subject_roi_name);
        
        %% Masked data:
        masked{sub} = mvpalab_maskbetas(subject_roi,subject_betas);
        
        %% Prepare data: [betas x voxels]
        masked{sub} = mvpalab_combineruns(cfg,masked{sub});
        
        %% Condition label of each beta:
        %  mvpalab_combineruns stacks the betas condition by condition
        %  (all the runs of condition 1, then condition 2...).

        [nconds,nruns] = size(subject_betas);
        labels = categorical(repelem((1:nconds)',nruns));

        %% Noise precision matrix if needed:
        %  For the Mahalanobis distance the noise is estimated from the
        %  residuals of the betas (each beta minus the mean of its condition
        %  across runs), see mvpalab_noiseprec.

        if strcmp(dist,'mahalanobis')
            prec = mvpalab_noiseprec(masked{sub},labels);
        else
            prec = [];
        end

        %% Extract RDM for each roi and subject:
        %  This function returns 2D matrices containing the RDMs according
        %  to the following structure:
        %  rdm - [n_betas x n_betas], n_betas = n_conditions x n_runs
        %  Without cross-validation the training and test patterns are the
        %  same betas.

        rdm{sub} = mvpalab_computerdm(cfg,masked{sub},masked{sub},[],prec);
        
        %% Merge conditions if needed:
        %  Combine conditions of different runs in a global condition if
        %  needed.
        %  rdm - [n_conditions x voxels]
        
        rdm{sub} = mvpalab_mergerunsrdm(cfg,subject_betas,rdm{sub});
        
        %% Vectorize RDMs:
        %  Both theoretical and empirical DRMs are vectorized in order to
        %  compute the Representational Similarity Analysis.
        %  vrdms - [1 x vectorized]
        
        vrdms{sub} = mvpalab_vectorizerdm(cfg,rdm{sub});
        
        %% Compute the Representational similarity analysis:
        %  Empirical and theoretical models are correlated to obtain the time
        %  resolved correlation coefficient.
        
        
    end
    
    %% Save RSA data
    res.(mode).(dist).(subject_roi_name).rdms = rdm;
    res.(mode).(dist).(subject_roi_name).theo = theo;
    
end



mvpalab_save(cfg,res,'res');

end