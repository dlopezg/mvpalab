function rdm = mvpalab_computerdm(cfg,train,test,prec)
%% MVPALAB_COMPUTERDM
%
%  This function computes the Representational Dissimilarity Matrix
%  between the training and test patterns of one timepoint. Without
%  cross-validation (cfg.rsa.nfolds = 1) train and test are the same data.
%
%  Distance measures (cfg.rsa.distance):
%
%  - 'pearson': 1 - Pearson correlation. With cross-validation, the
%    cross-validated Pearson distance (mvpalab_cvpearson).
%
%  - 'euclidean': squared Euclidean distance divided by the number of
%    features (mvpalab_cveuclidean). With cross-validation, the
%    cross-validated squared Euclidean distance.
%
%  - 'mahalanobis': squared Mahalanobis distance, i.e. the squared
%    Euclidean distance after multivariate noise normalization with the
%    noise precision matrix (mvpalab_noiseprec). With cross-validation it
%    is the crossnobis distance (cross-validated squared Mahalanobis
%    distance, mvpalab_cveuclidean with prec).
%
%  - 'crossnobis': same as 'mahalanobis' with cross-validation. It
%    requires cfg.rsa.nfolds > 1.
%
%  Multivariate noise normalization (cfg.rsa.mnn): for 'pearson' and
%  'euclidean' the patterns are whitened by the callers (mvpalab_rdm and
%  mvpalab_rsa_roi, see mvpalab_whitening) before calling this function.
%
%  Scale of the Euclidean family: 'euclidean', 'mahalanobis' and
%  'crossnobis' always return the SQUARED distance DIVIDED BY THE NUMBER
%  OF FEATURES (channels or voxels), with and without cross-validation:
%
%     d(i,j) = (A_i - A_j) * W * (B_i - B_j)' / nfeatures
%
%  with W = identity ('euclidean'), the noise precision ('mahalanobis',
%  'crossnobis'), A = B without cross-validation and A, B = training and
%  test patterns with cross-validation. Consequences:
%    - cfg.rsa.nfolds only changes the noise bias, not the scale or the
%      form of the distance, so the results with and without
%      cross-validation can be compared.
%    - 'euclidean' with cfg.rsa.mnn equals 'mahalanobis' (nfolds = 1) or
%      'crossnobis' (nfolds > 1).
%    - The distances do not grow with the number of features, so they can
%      be compared across ROIs or channel selections of different size.
%    - The squared distance is linear in the second moment of the
%      patterns, which is what the regression models assume (as in
%      rsatoolbox, calc_rdm with 'euclidean' or 'crossnobis').
%  Before version 1.3.0 the non-cross-validated 'euclidean' distance was
%  the plain Euclidean distance (pdist2, not squared and not divided by
%  the number of features). What changes with respect to those versions:
%    - The RDM values, and the beta and t-values of the 'regress' and
%      'multiple_regress' modalities.
%    - Not the Spearman correlation of the M/EEG analyses ('corr' modality),
%      which only depends on the ranks of the distances.
%    - Slightly, the fMRI ROI RDMs without cross-validation and the fusion
%      analyses that use them: these RDMs are the mean across pairs of runs
%      (mvpalab_mergerunsrdm), and the mean of the squared distances does
%      not have exactly the same ranks as the mean of the distances.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {matrix} - train:
%    Training patterns. [conditions x channels] or [trials x channels]
%
%  - {matrix} - test:
%    Test patterns, in the same order as train. Same data as train
%    without cross-validation.
%
%  - {matrix} - prec:
%    Noise precision matrix [channels x channels], estimated from the
%    training trials by mvpalab_rdm. Only used by 'mahalanobis' and
%    'crossnobis'.
%
%%  OUTPUT:
%
%  - {matrix} - rdm:
%    Representational Dissimilarity Matrix:
%    [trials x trials] or [n_conditions x n_conditions]
%

%% Pearson distance:
%  Without cross-validation train and test are the same data and the
%  standard Pearson correlation is used. With cross-validation (train and
%  test are independent partitions) the cross-validated Pearson
%  correlation of Guggenmos et al. (2018) is used, which is symmetric by
%  construction and corrects the attenuation of the correlation caused by
%  noise (see mvpalab_cvpearson for details and references).
%  The correlation is computed across features, so it is not defined for a
%  single feature (channel or voxel) and an error is raised, as in MNE-RSA.

if strcmp(cfg.rsa.distance, 'pearson')
    if size(train,2) < 2
        error('mvpalab:computerdm',...
            ['The Pearson (or cosine) distance is computed across ' ...
            'features and needs at least 2 features (channels or ' ...
            'voxels), but the data has %d. Use the Euclidean distance ' ...
            'or select more channels or voxels.'],size(train,2));
    end
    if cfg.rsa.nfolds > 1
        rdm = mvpalab_cvpearson(cfg,train,test);
    else
        rdm = mvpalab_pearson(cfg,train',test');
    end
    rdm = 1 - rdm;
%% Euclidean distance:
%  Squared Euclidean distance divided by the number of features, with and
%  without cross-validation (the same scale as the Mahalanobis and
%  crossnobis distances). With cross-validation it is the cross-validated
%  squared Euclidean distance of Guggenmos et al. (2018), unbiased and
%  possibly negative. Without cross-validation train and test are the
%  same data and it is the squared Euclidean distance between the
%  patterns, positively biased by the noise. See mvpalab_cveuclidean for
%  details and references, and the note on the scale below.

elseif strcmp(cfg.rsa.distance, 'euclidean')
    rdm = mvpalab_cveuclidean(train,test);
%% Mahalanobis and crossnobis distances:
%  The same kernel as the cross-validated Euclidean distance, computed
%  through the noise precision matrix: (A_i - A_j) * prec * (B_i - B_j)'.
%  With cross-validation this is the crossnobis distance of Walther et al.
%  (2016), unbiased and possibly negative. Without cross-validation it is
%  the squared Mahalanobis distance between the patterns, positively
%  biased by the noise (see mvpalab_cveuclidean and mvpalab_noiseprec).

elseif strcmp(cfg.rsa.distance, 'mahalanobis') || ...
        strcmp(cfg.rsa.distance, 'crossnobis')
    rdm = mvpalab_cveuclidean(train,test,prec);
else
    error('mvpalab:computerdm','Distance measure not recognized.');
end

end
