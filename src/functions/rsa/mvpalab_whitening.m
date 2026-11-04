function W = mvpalab_whitening(sigma)
%% MVPALAB_WHITENING
%
%  This function returns the whitening matrix W = sigma^(-1/2) used for the
%  multivariate noise normalization (MNN) of the patterns in RSA
%  (cfg.rsa.mnn). The patterns are whitened as x * W before computing the
%  dissimilarities, so that the noise of the whitened patterns has an
%  identity covariance: noisy channels are down-weighted and the noise
%  correlations between channels are removed.
%
%  - W is the symmetric inverse square root of sigma, computed from its
%    eigendecomposition: sigma = V * D * V', W = V * D^(-1/2) * V'. This is
%    the whitening matrix of Guggenmos et al. (2018), computed in their
%    reference code as fractional_matrix_power(sigma, -0.5).
%
%  - W * W' = inv(sigma), so the squared Euclidean distance between
%    whitened patterns is the squared Mahalanobis distance. In particular,
%    the cross-validated squared Euclidean distance of the whitened
%    patterns is the crossnobis distance. For the Pearson distance the
%    whitening cannot be written in terms of the precision matrix, because
%    the whitened patterns are centered across features, so it is applied
%    explicitly to the patterns.
%
%  - sigma must be positive definite. The shrinkage estimate of
%    mvpalab_noiseprec is positive definite unless a channel has zero
%    variance.
%
%%  REFERENCES:
%
%  - Guggenmos, M., Sterzer, P., & Cichy, R. M. (2018). Multivariate
%    pattern analysis for MEG: A comparison of dissimilarity measures.
%    NeuroImage, 173, 434-447.
%    https://doi.org/10.1016/j.neuroimage.2018.02.044
%    Reference code: https://github.com/m-guggenmos/megmvpa
%    (tutorial_python/python_distance.ipynb).
%
%%  INPUT:
%
%  - {2D-matrix} - sigma:
%    Noise covariance matrix (see mvpalab_noiseprec). [channels x channels]
%
%%  OUTPUT:
%
%  - {2D-matrix} - W:
%    Symmetric whitening matrix sigma^(-1/2). [channels x channels]

%% Symmetric inverse square root:

sigma = (sigma + sigma') / 2;
[V,D] = eig(sigma);
W = V * diag(1 ./ sqrt(diag(D))) * V';
W = (W + W') / 2;

end
