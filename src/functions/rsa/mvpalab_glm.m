function [b,t] = mvpalab_glm(vrdm,vmodels,pidx)
%% MVPALAB_GLM
%
%  This function fits a general linear model at each timepoint, with the
%  empirical RDM as the dependent variable and the theoretical RDMs as
%  regressors, with an intercept, for each row of pidx: the identity for
%  the observed map and one permutation of the conditions for each
%  permuted map (see mvpalab_rsapermidx). The empirical RDM is the one
%  permuted and the regressors stay fixed.
%
%  The regressors are the same at all the timepoints and maps, so the
%  least squares solution is computed for all the timepoints of a map at
%  once, with the QR decomposition of the regressors. The t-value of each
%  coefficient is the coefficient divided by its standard error, with the
%  residual variance of each timepoint. It gives the coefficients and the
%  t-values of fitlm, up to rounding errors (relative differences below
%  1e-9). A timepoint with a NaN in the empirical RDM gives NaN, as in the
%  Spearman correlation (mvpalab_spearmanz), while fitlm would leave out
%  that pair.
%
%%  INPUT:
%
%  - {matrix} - vrdm:
%    Vectorized empirical RDM [timepoints x pairs].
%
%  - {matrix} - vmodels:
%    Vectorized theoretical RDMs, the regressors [pairs x models].
%
%  - {matrix} - pidx:
%    Order of the pairs of each map [maps x pairs].
%
%%  OUTPUT:
%
%  - {matrix} - b:
%    Coefficient of each regressor [timepoints x maps x models].
%
%  - {matrix} - t:
%    t-value of each coefficient [timepoints x maps x models].

ntp = size(vrdm,1);
nmodels = size(vmodels,2);
b = zeros(ntp,size(pidx,1),nmodels);
t = b;

%% Regressors with the intercept, and the factors of the standard errors:
%  sqrt(diag(inv(X'*X))) = sqrt of the sum of the squares of each row of
%  inv(R), with X = Q*R.
X = [ones(size(vmodels,1),1) vmodels];
[Q,R] = qr(X,0);
dof = size(X,1) - size(X,2);
factors = sqrt(sum(inv(R).^2,2));

for map = 1 : size(pidx,1)
    Y = vrdm(:,pidx(map,:))';
    coef = R \ (Q'*Y);
    se = factors .* sqrt(sum((Y - X*coef).^2,1)/dof);
    b(:,map,:) = permute(coef(2:end,:),[2 3 1]);
    t(:,map,:) = permute(coef(2:end,:)./se(2:end,:),[2 3 1]);
end

end
