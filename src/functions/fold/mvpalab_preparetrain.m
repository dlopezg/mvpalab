function [X,fold] = mvpalab_preparetrain(cfg,X)
%% MVPALAB_PREPARETRAIN
%
%  This function fits the transformation of the data of one fold on its
%  training set and returns the transformed training set. The same
%  transformation is applied to each test set with mvpalab_preparetest:
%
%  1. Normalization (cfg.normdata = 3 or 4): each feature is z-scored with
%     the mean and the standard deviation of the training set, normalized
%     by N - 1 (3) or N (4). A feature with no variance is only centered.
%     The other values of cfg.normdata do not change the data here.
%  2. Dimensionality reduction (cfg.dimred.method = 'pca'): the training
%     set is replaced by its first cfg.dimred.ncomp principal components.
%     ncomp can be at most the number of components of the training set.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.normdata and cfg.dimred).
%
%  - {matrix} - X:
%    Training set of the fold [trials x features].
%
%%  OUTPUT:
%
%  - {matrix} - X:
%    Transformed training set [trials x features], with the principal
%    components as features if cfg.dimred.method = 'pca'.
%
%  - {struct} - fold:
%    Transformation of the fold:
%    - norm: Mean (u) and standard deviation (v) of each feature, 0 and 1
%      without normalization.
%    - pca: Mean (mu), coefficients (coeff) and number of components
%      (ncomp) of the principal components, empty without PCA.

fold.norm = fitnorm(cfg,X);
X = (X - fold.norm.u)./fold.norm.v;

fold.pca = [];
if strcmp(cfg.dimred.method,'pca')
    [coeff,scores,~,~,~,mu] = pca(X);
    if cfg.dimred.ncomp > size(scores,2)
        error('cfg.dimred.ncomp must be between 1 and %d.',size(scores,2));
    end
    fold.pca = struct('mu',mu,'coeff',coeff,'ncomp',cfg.dimred.ncomp);
    X = scores(:,1:cfg.dimred.ncomp);
end

end

function norm = fitnorm(cfg,X)
%% Mean and standard deviation of each feature of the training set.

norm.u = 0;
norm.v = 1;
if cfg.normdata < 3, return; end

% Weight of std: 0 normalizes by N - 1 and 1 by N:
weight = cfg.normdata == 4;

norm.u = mean(X,1);
norm.v = std(X,weight,1);
norm.v(norm.v == 0) = 1;

end
