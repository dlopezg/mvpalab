function covmatrix = mvpalab_computecovmat(data)
%% MVPALAB_COMPUTECOVMAT
%
%   This function computes the covariance matrix for the input data, while
%   making sure, that the result is symetric, square and positive definite.
%
%%  INPUT:
%
%  - {2D-matrix} - data:
%    Data matrix for an individual subject containing all the trials and
%    conditions. [trials x channels]
%    
%
%%  OUTPUT:
%
%  - {2D-matrix} - covmatrix:
%    A symetric, square and positive definite matrix.

[t, n] = size(data);
meanx = mean(data);
X = data - meanx(ones(t, 1), :);
    
% compute sample covariance matrix
sample = (1 / t) * (X' * X);

% ensure symmetry
sample = (sample + sample') / 2;

% compute prior
prior = diag(diag(sample));

% compute shrinkage parameters
d = 1 / n * norm(sample - prior, 'fro')^2;
y = X.^2;
r2 = 1 / n / t^2 * sum(sum(y' * y)) - 1 / n / t * sum(sum(sample.^2));

% compute the estimator
shrinkage = max(0, min(1, r2 / d));
covmatrix = shrinkage * prior + (1 - shrinkage) * sample;

covmatrix = pinv(covmatrix);

covmatrix = (covmatrix + covmatrix') / 2;

% test that covmatrix is in fact PD.
p = 1;
k = 0;
while p ~= 0
    [~, p] = chol(covmatrix);
    k = k + 1;
    if p ~= 0
        mineig = min(eig(covmatrix));
        covmatrix = covmatrix + (-mineig * k.^2 + eps(mineig)) * eye(size(covmatrix, 1));
        warning('Added %d to covariance matrix due to numerical issues.', -mineig * k.^2 + eps(mineig));
    end
end

% Check if the covariance matrix is positive definite
tol = 1e-3;
if any(eig(covmatrix) < -tol)
    warning('Covariance matrix may not be positive definite due to numerical issues.');
end

% check if square
if size(covmatrix, 1) ~= size(covmatrix, 2)
    warning('Covariance matrix is not square.');
end

% check if symmetric
if ~issymmetric(covmatrix)
    warning('Covariance matrix is not symmetric.');
end

% check if number of columns in X matches the covariance matrix
if size(X, 2) ~= size(covmatrix, 1)
    warning('Number of columns in X does not match the covariance matrix.');
end
end
