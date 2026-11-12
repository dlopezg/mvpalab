function [prec,sigma] = mvpalab_noiseprec(X,Y)
%% MVPALAB_NOISEPREC
%
%  This function estimates the noise covariance matrix of the channels
%  and its inverse (precision matrix), used by the Mahalanobis and
%  crossnobis distances to normalize the noise (multivariate noise
%  normalization). The covariance is also used to whiten the patterns of
%  the Pearson and Euclidean distances (cfg.rsa.mnn, mvpalab_whitening).
%
%  - Residuals: the noise is what remains after removing the signal of
%    each condition, i.e. each trial minus the mean of its condition. The
%    covariance is computed from these residuals and not from the trials,
%    because the trials also contain the differences between conditions
%    (the signal), which would then be partially removed by the noise
%    normalization. Degrees of freedom: number of trials minus number of
%    conditions (as in rsatoolbox, cov_from_unbalanced).
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
%  - Requirements: the residuals need more observations than conditions
%    (dof >= 1, i.e. at least one condition with two or more
%    observations), no NaN values, and every channel needs a residual
%    variance greater than zero (at least at one timepoint). The resulting
%    covariance must be positive definite, which can fail with very few
%    observations (e.g. dof = 1 with fewer timepoints than channels). An
%    error is raised otherwise, because the covariance would be undefined
%    or singular and the precision and whitening matrices NaN, infinite or
%    complex.
%
%  - fMRI: the observations are the betas of each condition and run, so
%    the residuals are the betas minus the mean of their condition across
%    runs. This needs at least 2 runs without cross-validation and at
%    least 3 runs with leave-one-run-out cross-validation (the training
%    set of each fold must include at least 2 runs). The recommended noise
%    estimate for fMRI is instead the residuals of the first-level GLM
%    (the time series minus the fitted model), as in rsatoolbox
%    (prec_from_residuals) and Walther et al. (2016): they are independent
%    of the betas and have many degrees of freedom (number of scans), so
%    the noise normalization is also possible with 2 runs and the
%    estimate is more stable. This option is not implemented yet: it
%    requires the residual time series of the first-level model, which
%    SPM does not save by default.
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
%    functions cov_from_unbalanced and _covariance_diag).
%
%%  INPUT:
%
%  - {matrix} - X:
%    Data matrix including all the trials. [trials x channels x timepoints]
%
%  - {categorical} - Y:
%    Condition label of each trial.
%
%%  OUTPUT:
%
%  - {matrix} - prec:
%    Noise precision matrix (inverse of sigma). [channels x channels]
%
%  - {matrix} - sigma:
%    Shrinkage estimate of the noise covariance matrix, averaged across
%    timepoints. [channels x channels]

[ntrials,nchannels,ntp] = size(X);
conds = unique(Y);
dof = ntrials - numel(conds);

%% Degrees of freedom of the residuals:
%  With a single observation per condition all the residuals are zero.

if dof < 1
    error('mvpalab:noiseprec',...
        ['The noise covariance (Mahalanobis and crossnobis distances, ' ...
        'cfg.rsa.mnn) needs more observations than conditions: %d ' ...
        'observations of %d conditions were found. In fMRI analyses ' ...
        'this requires at least 2 runs, and at least 3 runs with ' ...
        'leave-one-run-out cross-validation (cfg.rsa.nfolds > 1). Use ' ...
        'the Pearson or Euclidean distance without cfg.rsa.mnn ' ...
        'otherwise.'],ntrials,numel(conds));
end

%% Residuals: trials minus the mean of their condition

res = X;
for c = 1 : numel(conds)
    idx = Y == conds(c);
    res(idx,:,:) = X(idx,:,:) - mean(X(idx,:,:),1);
end

%% Channels without residual variance:
%  NaN values at any timepoint make the covariance undefined. A channel
%  whose residual variance is zero at all the timepoints (e.g. a reference
%  channel or a constant voxel) makes it singular. Zero variance at some
%  timepoints only (e.g. a zeroed artifact window) is allowed: at these
%  timepoints the channel adds no variance or covariance, the shrinkage of
%  the other channels is computed without it (see shrinkdiag), and the
%  average across timepoints is still positive definite.

ss = reshape(sum(res.^2,1),nchannels,ntp);
nanch = find(any(isnan(ss),2));
if ~isempty(nanch)
    error('mvpalab:noiseprec',...
        ['The noise covariance (Mahalanobis and crossnobis distances, ' ...
        'cfg.rsa.mnn) cannot be estimated from data with NaN values. ' ...
        '%d channel(s) with NaN values: %s.'],numel(nanch),mat2str(nanch'));
end
novar = find(all(ss == 0,2));
if ~isempty(novar)
    error('mvpalab:noiseprec',...
        ['The noise covariance (Mahalanobis and crossnobis distances, ' ...
        'cfg.rsa.mnn) needs a residual variance greater than zero in ' ...
        'every channel. %d channel(s) with zero variance at all the ' ...
        'timepoints: %s. Remove these channels or voxels from the ' ...
        'analysis.'],numel(novar),mat2str(novar'));
end

%% Shrinkage covariance at each timepoint, averaged across timepoints

sigma = zeros(nchannels);
for tp = 1 : ntp
    sigma = sigma + shrinkdiag(res(:,:,tp),dof);
end
sigma = sigma / ntp;

%% Positive definite covariance:
%  With very few observations (e.g. 3 trials of 2 conditions, dof = 1) the
%  optimal shrinkage intensity can be zero and the covariance singular.

if ~(rcond(sigma) > eps)
    error('mvpalab:noiseprec',...
        ['The noise covariance (Mahalanobis and crossnobis distances, ' ...
        'cfg.rsa.mnn) is singular: there are too few observations (%d ' ...
        'observations of %d conditions, %d channels) to estimate it. ' ...
        'Use more trials (or fewer folds) or the Pearson or Euclidean ' ...
        'distance without cfg.rsa.mnn.'],ntrials,numel(conds),nchannels);
end

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
%  lamb   - optimal shrinkage intensity for the off-diagonal elements,
%           computed with the channels that have variance at this
%           timepoint: a channel without variance has undefined
%           correlations, which would otherwise give lamb = 1 and remove
%           the covariances of all the channels. Its covariances are 0.

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
valid = mask & (v > 0) & (v > 0)';
lamb = sum(var_hat(valid)) / sum(s_mean(valid).^2);
lamb = max(min(lamb,1),0);
s_shrink = s .* (eye(size(s)) + (1 - lamb) * mask);

end
