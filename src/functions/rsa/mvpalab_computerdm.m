function rdm = mvpalab_computerdm(cfg, X, dims)
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
%  - {1D-array} - dims:
%    Dimensions of the subject_betas (only for fMRI). [rows, columns] = [regions, runs]
%
%
%%  OUTPUT:
%
%  - {2D-matrix} - rdm:
%    Representational Dissimilarity Matrix:
%    [trials x trials] or [n_conditions x n_conditions]
%

if cfg.rsa.normrdm
    X = zscore(X, [], [1, 2]);
end

if strcmp(cfg.rsa.distance, 'pearson')
    rdm = 1 - corrcoef(X');
elseif strcmp(cfg.rsa.distance, 'euclidean')
    rdm = pdist2(X, X, 'euclidean');
elseif strcmp(cfg.rsa.distance, 'mahalanobis')
    covMatrix = mvpalab_computecovmat(X);
    %rdm = pdist2(X, X, 'mahalanobis', covMatrix);
    rdm = mvpalab_computemahalanobis(X, covMatrix); 
elseif strcmp(cfg.rsa.distance, 'cvmahalanobis')
    rdm = mvpalab_cvmahalanobis(cfg, X, dims);
else
    rdm = zeros(size(X, 1), size(X, 1));
    error('Distance measure not recognized.');
end
end