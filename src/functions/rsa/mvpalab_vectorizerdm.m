function vrdm = mvpalab_vectorizerdm(cfg,rdm)
%% MVPALAB_VECTORIZERDM
%
%  This function returns the vectorized version of a temporal series of
%  RDMs in the form: [timepoints x vectorizedrdm x models]

%%  INPUT:
%
%  - {struct} cfg
%    Description: Configuration structure.
%
%  - {4D-matrix} rdm
%    Description: Representational Dissimilarity Matrices for each
%    timepoint and model. - [trials x trials x timepoints x models]
%
%%  OUTPUT:
%
%  - {3D-matrix} vrdm
%    Description: Vectorized version of a temporal series of RDMs in the
%    form: [timepoints x vectorizedrdm x models]
%

%% Remove diagonal and upper triangle:
%  RDMs are square and symmetrical matrices along its diagonal. For
%  computational efficiency both the diagonal and the upper triangle can be
%  removed for each timepoint.

for mdl = 1 : size(rdm,4)
    
    if cfg.classmodel.parcomp
        parfor tp = 1 : size(rdm,3)
            rdm_ = rdm(:,:,tp,mdl);
            rdm_(logical(eye(size(rdm_)))) = 0;
            vrdm(tp,:,mdl) = squareform(rdm_);
        end
    else
        for tp = 1 : size(rdm,3)
            rdm_ = rdm(:,:,tp,mdl);
            rdm_(logical(eye(size(rdm_)))) = 0;
            vrdm(tp,:,mdl) = squareform(rdm_);
        end
    end
    
end

end

