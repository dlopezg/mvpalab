function rdms = mvpalab_rdm(cfg,X)
%% MVPALAB_RDM
%
%  This function returns the trial-wise Representational Dissimilarity
%  Matrices for each timepoint.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {3D-matrix} - X:
%    Data matrix for an individual subject containing all thevtrials and 
%    conditions. [trials x chanels x timepoints]
%
%%  OUTPUT:
%
%  - {3D-matrix} - rdm:
%    Representational Dissimilarity Matrices for each timepoint:
%    [trials x trials x timepoints]
%

fprintf('     - Computing neural RDMs:');

%% Preallocate the RDM matrices:
ntrial = size(X,1);
ntp = size(X,3);
rdms = NaN(ntrial,ntrial,ntp);

%% Construct RDMs using Pearson correlation:
if strcmp(cfg.rsa.distance,'pearson')
    if cfg.classmodel.parcomp
        parfor tp = 1 : ntp
            X_tp = zscore(X(:,:,tp),[],[1,2]);
            rdms(:,:,tp) = 1 - corrcoef(X_tp');
        end
    else
        for tp = 1 : ntp
            X_tp = zscore(X(:,:,tp),[],[1,2]);
            rdms(:,:,tp) = 1 - corrcoef(X_tp');
        end
    end
end

%% Construct RDMs using the euclidean distance:
if strcmp(cfg.rsa.distance,'euclidean')
    if cfg.classmodel.parcomp
        parfor tp = 1 : ntp
            X_tp = zscore(X(:,:,tp),[],[1,2]);
            rdms(:,:,tp) = pdist2(X_tp,X_tp,'euclidean');
        end
    else
        for tp = 1 : ntp
            X_tp = zscore(X(:,:,tp),[],[1,2]);
            rdms(:,:,tp) = pdist2(X_tp,X_tp,'euclidean');
        end
    end
end

fprintf('- Done.\n\n');

end

