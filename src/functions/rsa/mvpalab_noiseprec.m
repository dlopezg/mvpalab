function [prec,sigma] = mvpalab_noiseprec(X,Y)
%% MVPALAB_NOISEPREC
%
%  This function estimates the noise covariance matrix of the channels
%  and its inverse (precision matrix), used by the Mahalanobis and
%  crossnobis distances to normalize the noise (multivariate noise
%  normalization).
%
%  - Residuals: the noise is what remains after removing the signal of
%    each condition, i.e. each trial minus the mean of its condition. The
%    covariance is computed from these residuals and not from the trials,
%    because the trials also contain the differences between conditions
%    (the signal), which would then be partially removed by the noise
%    normalization. Degrees of freedom: number of trials minus number of
%    conditions (as in rsatoolbox, cov_from_measurements).
%
%  - Shrinkage: with many channels and few trials the sample covariance
%    is unstable or singular. It is shrunk towards its diagonal with the
%    optimal shrinkage intensity of Schafer & Strimmer (2005, target "D":
%    the variances are kept and the correlations are shrunk towards zero).
%    The implementation follows rsatoolbox (method 'shrinkage_diag',
%    function _covariance_diag), which is its default estimator.
%
%  - Temporal average: the covariance is estimated at each timepoint and
%    averaged across all the timepoints of the epoch before computing the
%    precision matrix. This is the "epoch" method of Guggenmos et al.
%    (2018), recommended in that study for M/EEG data because it is more
%    stable than a timepoint-wise estimate. The same precision matrix is
%    then used for all the timepoints.
%
%  - Cross-validation: in cross-validated analyses this function must be
%    called with the training trials only (see mvpalab_rdm), so that the
%    test data does not influence the noise normalization (as in
%    Guggenmos et al., 2018).
%
%%  REFERENCES:
%
%  - Schafer, J., & Strimmer, K. (2005). A shrinkage approach to
%    large-scale covariance matrix estimation and implications for
%    functional genomics. Statistical Applications in Genetics and
%    Molecular Biology, 4(1), Article 32.
%    https://doi.org/10.2202/1544-6115.1175
%
%  - Guggenmos, M., Sterzer, P., & Cichy, R. M. (2018). Multivariate
%    pattern analysis for MEG: A comparison of dissimilarity measures.
%    NeuroImage, 173, 434-447.
%    https://doi.org/10.1016/j.neuroimage.2018.02.044
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
%    Code: https://github.com/rsagroup/rsatoolbox (rsatoolbox/data/noise.py,
%    functions cov_from_measurements and _covariance_diag).
%
%%  INPUT:
%
%  - {3D-matrix} - X:
%    Data matrix including all the trials. [trials x channels x timepoints]
%
%  - {1D-categorical} - Y:
%    Condition label of each trial.
%
%%  OUTPUT:
%
%  - {2D-matrix} - prec:
%    Noise precision matrix (inverse of sigma). [channels x channels]
%
%  - {2D-matrix} - sigma:
%    Shrinkage estimate of the noise covariance matrix, averaged across
%    timepoints. [channels x channels]

[ntrials,nchannels,ntp] = size(X);
conds = unique(Y);
dof = ntrials - numel(conds);

%% Residuals: trials minus the mean of their condition

res = X;
for c = 1 : numel(conds)
    idx = Y == conds(c);
    res(idx,:,:) = X(idx,:,:) - mean(X(idx,:,:),1);
end

%% Shrinkage covariance at each timepoint, averaged across timepoints

sigma = zeros(nchannels);
for tp = 1 : ntp
    sigma = sigma + shrinkdiag(res(:,:,tp),dof);
end
sigma = sigma / ntp;

%% Precision matrix

prec = inv(sigma);
prec = (prec + prec') / 2;

end

function s_shrink = shrinkdiag(res,dof)
%% Shrinkage towards the diagonal (Schafer & Strimmer, 2005, target D)
%  Line by line implementation of _covariance_diag in rsatoolbox:
%  s      - sample covariance (sum of outer products / dof)
%  s_mean - sample correlation matrix (normalized by n-1)
%  s2_mean- mean of the squared standardized products
%  var_hat- estimated variance of the sample correlations
%  lamb   - optimal shrinkage intensity for the off-diagonal elements

n = size(res,1);
s_sum  = res' * res;
s2_sum = (res.^2)' * (res.^2);
s = s_sum / dof;
v = diag(s);
sd = sqrt(v);
s_mean  = s_sum  ./ (sd * sd') / (n - 1);
s2_mean = s2_sum ./ (v * v')   / (n - 1);
var_hat = n / dof^2 * (s2_mean - s_mean.^2);
mask = ~eye(size(s));
lamb = sum(var_hat(mask)) / sum(s_mean(mask).^2);
lamb = max(min(lamb,1),0);
s_shrink = s .* (eye(size(s)) + (1 - lamb) * mask);

end
