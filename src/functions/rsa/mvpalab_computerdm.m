function rdm = mvpalab_computerdm(cfg,X)
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
%    conditions. [trials x chanels]
%
%%  OUTPUT:
%
%  - {2D-matrix} - rdm:
%    Representational Dissimilarity Matrix:
%    [trials x trials] or [n_conditions x n_conditions]
%

if cfg.rsa.normrdm
    X = zscore(X,[],[1,2]);
end

if strcmp(cfg.rsa.distance,'pearson')
    rdm = 1 - corrcoef(X');
elseif strcmp(cfg.rsa.distance,'euclidean')
    rdm = pdist2(X,X,'euclidean');
else
    
end

end

