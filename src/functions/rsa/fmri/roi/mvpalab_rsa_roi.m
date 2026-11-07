function [res,stats,cfg] = mvpalab_rsa_roi(cfg,volumes,masks)
%% MVPALAB_RSA_ROI
%
%  This function computes the condition-wise RDM of each region of interest
%  and subject from the fMRI betas (one beta per condition and run).
%
%  - Without cross-validation (cfg.rsa.nfolds = 1): the dissimilarity is
%    computed between all the betas (conditions x runs) and the run blocks
%    are averaged (mvpalab_mergerunsrdm). The average includes pairs of
%    betas estimated in the same run, which share the noise of that run
%    (scanner drifts, head motion, physiological noise...), so the
%    dissimilarities are affected by this shared noise.
%
%  - With cross-validation (cfg.rsa.nfolds > 1): leave-one-run-out. Each
%    run is used once as test set and the average of the remaining runs as
%    training set, so the two patterns compared in each dissimilarity are
%    always estimated from different runs (cross-validated Pearson,
%    cross-validated Euclidean or crossnobis distances, see
%    mvpalab_computerdm). The folds are always the runs: the value of
%    cfg.rsa.nfolds only enables the cross-validation. This is the
%    standard partition for cross-validated distances in fMRI (Walther et
%    al., 2016; rsatoolbox, calc_rdm with the run as cv_descriptor).
%
%  - Noise normalization (Mahalanobis and crossnobis distances,
%    cfg.rsa.mnn): the noise covariance is estimated from the residuals of
%    the betas across runs (see mvpalab_noiseprec). It needs at least 2
%    runs, and at least 3 runs with cross-validation. The recommended
%    estimate, the residuals of the first-level GLM (Walther et al., 2016;
%    rsatoolbox, prec_from_residuals), also works with 2 runs but is not
%    implemented yet.
%
%  Walther, A., Nili, H., Ejaz, N., Alink, A., Kriegeskorte, N., &
%  Diedrichsen, J. (2016). Reliability of dissimilarity measures for
%  multi-voxel pattern analysis. NeuroImage, 137, 188-200.
%  https://doi.org/10.1016/j.neuroimage.2015.12.012
%
%  The RDMs are not compared with the theoretical models: the result
%  includes the RDMs and the theoretical RDMs, and is saved with
%  mvpalab_save.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - volumes:
%    Betas of each subject, each one a cell array [conditions x runs] (see
%    mvpalab_import_fmri and mvpalab_load_betas).
%
%  - {cell array} - masks:
%    Regions of interest of each subject, each one a struct with one field
%    per region in the order of cfg.rsa.roi (see mvpalab_import_fmri and
%    mvpalab_load_volumes).
%
%%  OUTPUT:
%
%  - {struct} - res:
%    Results in res.(cfg.rsa.modality).(cfg.rsa.distance).(region), with
%    the names of the fields of masks:
%    - rdms: Cell array with the RDM of each subject [conditions x
%      conditions].
%    - theo: Theoretical RDMs [conditions x conditions x 1 x models] (see
%      mvpalab_gentrdms).
%
%  - {struct} - stats:
%    Empty structure.
%
%  - {struct} - cfg:
%    Configuration structure, without changes.

%% Initialize
stats = struct();
mode = cfg.rsa.modality;
dist = cfg.rsa.distance;
crossval = cfg.rsa.nfolds > 1;

if ~crossval && strcmp(dist,'crossnobis')
    error(['The crossnobis distance is cross-validated and requires ' ...
        'cfg.rsa.nfolds > 1. Use cfg.rsa.distance = ''mahalanobis'' ' ...
        'without cross-validation.']);
end

%  Leave-one-run-out RDMs are condition-wise:
cfgcv = cfg;
cfgcv.rsa.trialwise = false;

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
        
        %% Condition and run of each beta:
        %  mvpalab_combineruns stacks the betas condition by condition
        %  (all the runs of condition 1, then condition 2...).

        [nconds,nruns] = size(subject_betas);
        labels = categorical(repelem((1:nconds)',nruns));
        runs = repmat((1:nruns)',nconds,1);

        if crossval
            %% Leave-one-run-out cross-validated RDM:
            %  mvpalab_rdm uses the runs as folds: training patterns are the
            %  mean of the betas of the other runs, test patterns the betas
            %  of the left-out run, and the RDMs are averaged across runs.
            %  The noise precision matrix (Mahalanobis/crossnobis) is
            %  estimated from the training betas of each fold.
            %  rdm - [n_conditions x n_conditions]

            cvrdm = mvpalab_rdm(cfgcv,masked{sub},labels,runs);
            rdm{sub} = cvrdm.rdm;
        else
            %% Noise precision matrix if needed:
            %  For the Mahalanobis distance the noise is estimated from the
            %  residuals of the betas (each beta minus the mean of its
            %  condition across runs), see mvpalab_noiseprec.

            %  With multivariate noise normalization (cfg.rsa.mnn) the
            %  Pearson and Euclidean distances are computed between the
            %  whitened betas (see mvpalab_whitening).

            prec = [];
            if strcmp(dist,'mahalanobis')
                prec = mvpalab_noiseprec(masked{sub},labels);
            elseif cfg.rsa.mnn
                [~,sigma] = mvpalab_noiseprec(masked{sub},labels);
                masked{sub} = masked{sub} * mvpalab_whitening(sigma);
            end

            %% Extract RDM for each roi and subject:
            %  rdm - [n_betas x n_betas], n_betas = n_conditions x n_runs
            %  Without cross-validation the training and test patterns are
            %  the same betas.

            rdm{sub} = mvpalab_computerdm(cfg,masked{sub},masked{sub},[],prec);

            %% Merge conditions:
            %  Average the run blocks of each pair of conditions.
            %  rdm - [n_conditions x n_conditions]

            rdm{sub} = mvpalab_mergerunsrdm(cfg,subject_betas,rdm{sub});
        end
        
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