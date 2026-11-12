function d = mvpalab_cveuclidean(train,test,prec)
%% MVPALAB_CVEUCLIDEAN
%
%  Crossnobis: if a noise precision matrix is provided (prec, see
%  mvpalab_noiseprec), the differences are computed in the space of the
%  noise (multivariate noise normalization), which gives the crossnobis
%  distance of Walther et al. (2016), the cross-validated squared
%  Mahalanobis distance:
%
%   d(i,j) = (A_i - A_j) * prec * (B_i - B_j)' / nfeatures
%
%  as in rsatoolbox (calc_rdm with method 'crossnobis' and the noise
%  precision as 'noise'). Without prec the identity is used, i.e. the
%  cross-validated squared Euclidean distance described below. If train
%  and test are the same data (no cross-validation) the result is the
%  squared Euclidean (or Mahalanobis) distance, which is positively
%  biased by the noise.
%
%  This function computes the cross-validated squared Euclidean distance
%  between all pairs of conditions for one cross-validation fold. It is
%  the cross-validated Euclidean distance recommended by Guggenmos et al.
%  (2018) for RSA of MEG data, and the crossnobis distance of Walther et
%  al. (2016) without noise normalization (identity noise covariance).
%  It is implemented, with the same formula, in:
%    - the reference code of Guggenmos et al. (2018), class CvEuclidean2;
%    - rsatoolbox, calc_rdm with method 'crossnobis' and identity noise
%      (function _calc_rdm_crossnobis_single);
%    - MNE-RSA, compute_rdm_cv with metric 'sqeuclidean' (function
%      _cv_sq_general);
%    - The Decoding Toolbox (TDT), which lists 'cveuclidean2' as the
%      cross-validated version of the squared Euclidean distance.
%
%  Let A_i and B_i be the patterns of condition i estimated in two
%  independent partitions of the data (training and test). The
%  cross-validated squared Euclidean distance between conditions i and j
%  is the product of the difference between both conditions estimated in
%  each partition:
%
%   d(i,j) = (A_i - A_j) * (B_i - B_j)' / nfeatures
%
%  - Unbiased: each pattern is the true pattern plus noise. The squared
%    distance computed from a single partition, ||A_i - A_j||^2, includes
%    the squared noise, which is always positive, so it overestimates the
%    true distance (also when two conditions do not differ at all). In
%    the cross-validated product the noise of A and B is independent, the
%    cross terms cancel out on average, and d(i,j) is an unbiased estimate
%    of the true squared distance ||mu_i - mu_j||^2.
%
%  - Meaningful zero: if two conditions do not differ, d(i,j) is zero on
%    average. Because of the noise it can be negative, which is expected
%    (it is technically not a distance anymore). For this reason the
%    squared distance is returned: the square root is not defined for
%    negative values. A monotonic transformation does not affect the
%    Spearman correlation with the theoretical models, but it changes the
%    results of a linear regression.
%
%  - Symmetric with zero diagonal: swapping i and j changes the sign of
%    both differences, so d(i,j) = d(j,i), and d(i,i) = 0 by construction.
%
%  - Different from a distance between training and test patterns,
%    pdist2(train,test): ||A_i - B_j|| adds the noise of both partitions
%    (it is more biased than the non-cross-validated distance), it is not
%    symmetric and its diagonal is not zero.
%
%  Computation: with the kernel K = A * B', the distance is
%  d(i,j) = K(i,i) + K(j,j) - K(i,j) - K(j,i), as in rsatoolbox.
%
%  Normalization: the distance is divided by the number of features, as in
%  rsatoolbox, so that it does not depend on the number of channels. The
%  reference code of Guggenmos et al. (2018) and MNE-RSA do not normalize.
%  This only rescales the RDM.
%
%  Folds: this function processes one fold. As in rsatoolbox and MNE-RSA,
%  mvpalab_rdm averages the distances across folds, where each fold is
%  used once as test set and the average of the remaining folds as
%  training set. This is approximately equivalent (exactly with balanced
%  folds) to averaging the product over all pairs of different folds
%  (MNE-RSA, _cv_sq_general).
%
%  Noise normalization (the crossnobis distance, see above) is recommended
%  by Walther et al. (2016) and Guggenmos et al. (2018).
%
%%  REFERENCES:
%
%  - Guggenmos, M., Sterzer, P., & Cichy, R. M. (2018). Multivariate
%    pattern analysis for MEG: A comparison of dissimilarity measures.
%    NeuroImage, 173, 434-447.
%    https://doi.org/10.1016/j.neuroimage.2018.02.044
%    Reference code: https://github.com/m-guggenmos/megmvpa
%    (tutorial_python/dissimilarity.py, class CvEuclidean2).
%
%  - Walther, A., Nili, H., Ejaz, N., Alink, A., Kriegeskorte, N., &
%    Diedrichsen, J. (2016). Reliability of dissimilarity measures for
%    multi-voxel pattern analysis. NeuroImage, 137, 188-200.
%    https://doi.org/10.1016/j.neuroimage.2015.12.012
%
%  - van den Bosch, J. J. F., Golan, T., Peters, B., Taylor, J., Shahbazi,
%    M., Lin, B., Charest, I., Diedrichsen, J., Kriegeskorte, N., et al.
%    (2025). A Python toolbox for representational similarity analysis
%    (rsatoolbox). bioRxiv. https://doi.org/10.1101/2025.05.22.655542
%    Code: https://github.com/rsagroup/rsatoolbox (rsatoolbox/rdm/calc.py,
%    functions calc_rdm_crossnobis and _calc_rdm_crossnobis_single).
%
%  - van Vliet, M., Appelhoff, S., Shimizu, T., Eremin, E., Hulten, A.,
%    Zhao, Y., & Hochenberger, R. (2025). MNE-RSA: Representational
%    Similarity Analysis on EEG, MEG and fMRI data. Journal of Open Source
%    Software, 10(116), 9148. https://doi.org/10.21105/joss.09148
%    Code: https://github.com/mne-tools/mne-rsa (mne_rsa/rdm.py,
%    functions compute_rdm_cv and _cv_sq_general).
%
%  - Hebart, M. N., Gorgen, K., & Haynes, J.-D. (2015). The Decoding
%    Toolbox (TDT): a versatile software package for multivariate analyses
%    of functional imaging data. Frontiers in Neuroinformatics, 8, 88.
%    https://doi.org/10.3389/fninf.2014.00088
%
%%  INPUT:
%
%  - {matrix} - train:
%    Training patterns for each condition. [conditions x features]
%
%  - {matrix} - test:
%    Test patterns for each condition, in the same order as train.
%    [conditions x features]
%
%  - {matrix} - prec (optional):
%    Noise precision matrix for the crossnobis distance.
%    [features x features]. Identity if not provided.
%
%%  OUTPUT:
%
%  - {matrix} - d:
%    Symmetric cross-validated squared Euclidean (or crossnobis)
%    distances with zero diagonal. [conditions x conditions]

%% Kernel between training and test patterns:
%  K(i,j) = A_i * prec * B_j'

if nargin < 3 || isempty(prec)
    K = train * test';
else
    K = train * prec * test';
end
k = diag(K);

%% Cross-validated squared Euclidean distance:
%  d(i,j) = (A_i - A_j) * (B_i - B_j)' = K(i,i) + K(j,j) - K(i,j) - K(j,i)
%  Both sums are grouped so that d is exactly symmetric in floating point.

d = ((k + k') - (K + K')) / size(train,2);

%% Exact zero diagonal:
%  Removes rounding errors of the kernel expansion.

d(logical(eye(size(d)))) = 0;

end
