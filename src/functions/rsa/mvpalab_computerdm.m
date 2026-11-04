function rdm = mvpalab_computerdm(cfg, train, test, dims)
%% MVPALAB_RDM
%
%  This function computes the Representational Dissimilarity Matrix.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {2D-matrix} - X:
%    Data matrix for an individual subject containing all the trials and
%    conditions. [trials x channels]
%
%  - {1D-categorical} - Y:
%    Categorical vector including data labels
%
%  - {1D-array} - dims:
%    Dimensions of the subject_betas (only for fMRI).
%    [rows, columns] = [regions, runs]
%
%%  OUTPUT:
%
%  - {2D-matrix} - rdm:
%    Representational Dissimilarity Matrix:
%    [trials x trials] or [n_conditions x n_conditions]
%


%% Normalización?
% if cfg.rsa.normrdm
%     X = zscore(X, [], [1, 2]);
% end


%% Pearson distance:
%  Without cross-validation train and test are the same data and the
%  standard Pearson correlation is used. With cross-validation (train and
%  test are independent partitions) the cross-validated Pearson
%  correlation of Guggenmos et al. (2018) is used, which is symmetric by
%  construction and corrects the attenuation of the correlation caused by
%  noise (see mvpalab_cvpearson for details and references).

if strcmp(cfg.rsa.distance, 'pearson')
    if cfg.cv.nfolds > 1
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
    if cfg.cv.nfolds > 1
        rdm = mvpalab_cveuclidean(train,test);
    else
        rdm = pdist2(train, test, 'euclidean');
    end
elseif strcmp(cfg.rsa.distance, 'mahalanobis')
    % covMatrix = mvpalab_computecovmat(X);
    % rdm = pdist2(X, X, 'mahalanobis', covMatrix);
    % rdm = mvpalab_computemahalanobis(X, covMatrix);
elseif strcmp(cfg.rsa.distance, 'cvmahalanobis')
    % rdm = mvpalab_cvmahalanobis(cfg, X, dims);
else
    rdm = zeros(size(train, 1), size(test, 1));
    error('Distance measure not recognized.');
end

end