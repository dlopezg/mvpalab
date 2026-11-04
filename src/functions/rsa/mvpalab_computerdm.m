function rdm = mvpalab_computerdm(cfg, train, test, dims, prec)
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
%  - 'euclidean': Euclidean distance. With cross-validation, the
%    cross-validated squared Euclidean distance (mvpalab_cveuclidean).
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
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {2D-matrix} - train:
%    Training patterns. [conditions x channels] or [trials x channels]
%
%  - {2D-matrix} - test:
%    Test patterns, in the same order as train. Same data as train
%    without cross-validation.
%
%  - {1D-array} - dims:
%    Not used. Kept for compatibility with previous versions.
%
%  - {2D-matrix} - prec:
%    Noise precision matrix [channels x channels], estimated from the
%    training trials by mvpalab_rdm. Only used by 'mahalanobis' and
%    'crossnobis'.
%
%%  OUTPUT:
%
%  - {2D-matrix} - rdm:
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

if strcmp(cfg.rsa.distance, 'pearson')
    if cfg.rsa.nfolds > 1
        rdm = mvpalab_cvpearson(train,test,cfg);
    else
        rdm = mvpalab_pearson(train',test',cfg);
    end
    rdm = 1 - rdm;
%% Euclidean distance:
%  Without cross-validation the standard Euclidean distance is used. With
%  cross-validation the cross-validated squared Euclidean distance of
%  Guggenmos et al. (2018) is used, which is unbiased, symmetric and has a
%  zero diagonal by construction. It is a squared distance and can be
%  negative (see mvpalab_cveuclidean for details and references).

elseif strcmp(cfg.rsa.distance, 'euclidean')
    if cfg.rsa.nfolds > 1
        rdm = mvpalab_cveuclidean(train,test);
    else
        rdm = pdist2(train, test, 'euclidean');
    end
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
    error('Distance measure not recognized.');
end

end
