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
%    Data matrix for an individual subject containing all the trials and
%    conditions. [trials x chanels x timepoints]
%
%%  OUTPUT:
%
%  - {3D-matrix} - rdm:
%    Representational Dissimilarity Matrices for each timepoint:
%    [trials x trials x timepoints]
%

fprintf('   - Computing neural RDMs:');

%% Preallocate the RDM matrices:
ntrial = size(X,1);
ntp = size(X,3);
rdms = NaN(ntrial,ntrial,ntp);

%% Construct RDMs using the specified distance measure:

if cfg.classmodel.parcomp && ntp > 1
    parfor tp = 1 : ntp
        rdms(:,:,tp) = mvpalab_computerdm(cfg,X(:,:,tp));
    end
else
    for tp = 1 : ntp
        rdms(:,:,tp) = mvpalab_computerdm(cfg,X(:,:,tp));
    end
end

fprintf('- Done.\n\n');

end

