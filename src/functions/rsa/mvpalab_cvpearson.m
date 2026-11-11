function r = mvpalab_cvpearson(train,test,cfg)
%% MVPALAB_CVPEARSON
%
%  This function computes the cross-validated Pearson correlation between
%  all pairs of conditions for one cross-validation fold. It implements
%  the cross-validated Pearson distance proposed by Guggenmos et al.
%  (2018) as implemented in their reference code (class CvPearson in
%  dissimilarity.py) and, in vectorized form, in MNE-RSA (function
%  _cv_cosine used by compute_rdm_cv for the 'correlation' metric).
%
%  Let A_i and B_i be the patterns of condition i estimated in two
%  independent partitions of the data (training and test). The
%  cross-validated correlation between conditions i and j is:
%
%            [cov(A_i,B_j) + cov(A_j,B_i)] / 2
%   r(i,j) = ----------------------------------
%            sqrt( cov(A_i,B_i) * cov(A_j,B_j) )
%
%  - Numerator: the cross-covariance is computed in both directions
%    (training pattern of i with test pattern of j, and vice versa) and
%    averaged. A single direction, as in mvpalab_pearson(train,test), is
%    not symmetric: r(A_i,B_j) and r(A_j,B_i) use different data. The
%    average makes the correlation matrix symmetric by construction.
%
%  - Denominator: the variances are replaced by cross-validated
%    variances, i.e. the covariance between the two independent estimates
%    of the same condition, cov(A_i,B_i). The noise of A_i and B_i is
%    independent, so cov(A_i,B_i) estimates the variance of the true
%    pattern without the noise variance. In the non-cross-validated
%    Pearson correlation the noise inflates the variances in the
%    denominator, so the correlation is attenuated towards zero (and the
%    distance 1-r biased towards 1) by an amount that depends on the
%    reliability of each condition. The cross-validated denominator
%    corrects this attenuation.
%
%  - Regularization: cov(A_i,B_i) can be close to zero or negative when
%    a condition carries little signal (e.g. before stimulus onset), which
%    would make r(i,j) unstable. As in Guggenmos et al. (2018) and
%    MNE-RSA, two lower bounds are applied (same default factors):
%      1) Each cross-validated variance is bounded below by 0.1 times the
%         non-cross-validated variance of the training pattern:
%            v_i = max( cov(A_i,B_i), 0.1 * var(A_i) )
%      2) The denominator is bounded below by 0.25 times the
%         non-cross-validated denominator:
%            den(i,j) = max( sqrt(v_i*v_j), 0.25*sqrt(var(A_i)*var(A_j)) )
%      Finally r(i,j) is bounded to [-1,1].
%    The bounds keep NaN values ('includenan'): a pattern with NaN values
%    gives NaN correlations, as the other distance measures, instead of
%    being replaced by the bounds (by default max and min ignore NaN).
%    Here the non-cross-validated variances are computed from the
%    training patterns of each pair of conditions, as in Guggenmos et al.
%    (2018). MNE-RSA uses instead the variance of the pattern averaged
%    across all folds and, for the second bound, its mean across
%    conditions. Both choices differ whenever a bound is active, which
%    for the single bound of MNE-RSA can also happen at a high
%    signal-to-noise ratio, for conditions with a low pattern variance
%    compared with the others.
%
%  - All the (co)variances are computed with the same normalization
%    (1/nfeatures), as in MNE-RSA. The reference code of Guggenmos et al.
%    (2018) uses np.cov (1/(n-1)) for the covariances and np.var (1/n)
%    for the regularization terms. The normalization cancels out in r and
%    only rescales the regularization bounds by n/(n-1).
%
%  Constant patterns: a pattern with the same value in all the features
%  (e.g. a timepoint set to zero in all the channels) is zero after the
%  centering, so its correlations are 0/0 = NaN: the correlation is not
%  defined. Use the Euclidean distance or exclude these timepoints.
%
%  The diagonal of the returned matrix is exactly 1 (the correlation of a
%  condition with itself), so the diagonal of the distance 1-r is exactly
%  0, as in mvpalab_cveuclidean. The regularization only applies to pairs
%  of conditions: without this, it would give meaningless values in the
%  diagonal at low signal-to-noise ratios. The reference implementations
%  only compute the pairs of different conditions.
%
%  If train and test are the same data (no cross-validation), the
%  cross-validated variances equal the variances, the regularization has
%  no effect and r is the standard Pearson correlation.
%
%  Folds: this function processes one fold. As in MNE-RSA
%  (compute_rdm_cv), mvpalab_rdm averages the resulting distances 1-r
%  across folds, where each fold is used once as test set and the
%  average of the remaining folds as training set.
%
%%  REFERENCES:
%
%  - Guggenmos, M., Sterzer, P., & Cichy, R. M. (2018). Multivariate
%    pattern analysis for MEG: A comparison of dissimilarity measures.
%    NeuroImage, 173, 434-447.
%    https://doi.org/10.1016/j.neuroimage.2018.02.044
%    Reference code: https://github.com/m-guggenmos/megmvpa
%    (tutorial_python/dissimilarity.py, class CvPearson).
%
%  - van Vliet, M., Appelhoff, S., Shimizu, T., Eremin, E., Hulten, A.,
%    Zhao, Y., & Hochenberger, R. (2025). MNE-RSA: Representational
%    Similarity Analysis on EEG, MEG and fMRI data. Journal of Open Source
%    Software, 10(116), 9148. https://doi.org/10.21105/joss.09148
%    Code: https://github.com/mne-tools/mne-rsa (mne_rsa/rdm.py,
%    functions compute_rdm_cv and _cv_cosine).
%
%  - Walther, A., Nili, H., Ejaz, N., Alink, A., Kriegeskorte, N., &
%    Diedrichsen, J. (2016). Reliability of dissimilarity measures for
%    multi-voxel pattern analysis. NeuroImage, 137, 188-200.
%    https://doi.org/10.1016/j.neuroimage.2015.12.012
%
%%  INPUT:
%
%  - {2D-matrix} - train:
%    Training patterns for each condition. [conditions x features]
%
%  - {2D-matrix} - test:
%    Test patterns for each condition, in the same order as train.
%    [conditions x features]
%
%  - {struct} - cfg:
%    Configuration structure. If cfg.rsa.meancenter is true each pattern
%    is centered across features (Pearson correlation). Otherwise the
%    patterns are not centered (cosine similarity, as the 'cosine' metric
%    of MNE-RSA).
%
%%  OUTPUT:
%
%  - {2D-matrix} - r:
%    Symmetric cross-validated correlation matrix.
%    [conditions x conditions]

%% Regularization factors:
%  Default values of Guggenmos et al. (2018) and MNE-RSA (reg_factor_var /
%  reg_var and reg_factor_denom / reg_denom).

regvar = 0.1;
regden = 0.25;

%% Center each pattern across features if needed:

if cfg.rsa.meancenter
    train = train - mean(train,2);
    test  = test  - mean(test,2);
end

nfeatures = size(train,2);

%% Cross-validated covariances:
%  G(i,j) = cov(A_i,B_j). The diagonal G(i,i) = cov(A_i,B_i) contains the
%  cross-validated variance of each condition.

G = (train * test') / nfeatures;
vcv = diag(G)';

%% Non-cross-validated variances of the training patterns:
%  Only used for the regularization.

vtrain = sum(train.^2,2)' / nfeatures;

%% Denominator with regularization:

vcv = max(vcv, regvar * vtrain, 'includenan');
den = sqrt(vcv') * sqrt(vcv);
den = max(den, regden * (sqrt(vtrain') * sqrt(vtrain)), 'includenan');

%% Symmetric cross-validated correlation:
%  Numerator averaged across both directions, bounded to [-1,1].

r = ((G + G') / 2) ./ den;
r = min(max(r,-1,'includenan'),1,'includenan');

%% Exact diagonal:
%  The correlation of a condition with itself is 1 by definition.

r(logical(eye(size(r)))) = 1;

end
