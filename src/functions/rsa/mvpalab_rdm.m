function rdm = mvpalab_rdm(cfg,X)
%% MVPALAB_RDM
%
%  This function returns the Representational Dissimilarity Matrices for
%  in a time resolved way.
%
%  INPUT:
%
%  - cfg: (STRUCT) Configuration estructure.
%
%  - X  : (MATRIX) Data matrix for an individual subject containing all the
%         trials and conditions. [trials x chanels x timepoints]
%
%  OUTPUT:
%
%  - rdm : (3D-MATRIX) Representational Dissimilarity Matrices for each
%          timepoint [trials x trials x timepoints]

fprintf('     <strong>- Computing empirical RDMs...</strong> ');

%% Preallocate the RDM matrices:
ntrial = size(X,1);
rdm = NaN(ntrial,ntrial,cfg.tm.ntp);

%% Construct RDMs using Pearson correlation:
if strcmp(cfg.rsa.method,'pearson')
    if cfg.classmodel.parcomp
        parfor tp = 1 : cfg.tm.ntp
            X_tp = X(:,:,tp);
            rdm(:,:,tp) = 1 - corrcoef(X_tp');
        end
    else
        for tp = 1 : cfg.tm.ntp
            X_tp = X(:,:,tp);
            rdm(:,:,tp) = 1 - corrcoef(X_tp');
        end
    end
end

%% Construct RDMs using the euclidean distance:
if strcmp(cfg.rsa.method,'euclidean')
    if cfg.classmodel.parcomp
        parfor tp = 1 : cfg.tm.ntp
            X_tp = X(:,:,tp);
            rdm(:,:,tp) = pdist2(X_tp,X_tp,'euclidean');
        end
    else
        for tp = 1 : cfg.tm.ntp
            X_tp = X(:,:,tp);
            rdm(:,:,tp) = pdist2(X_tp,X_tp,'euclidean');
        end
    end
end

fprintf('- Done.\n\n');

end

