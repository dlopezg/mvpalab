function vrdm = mvpalab_vectorizerdm(rdm)
%% MVPALAB_VECTORIZERDM
%
%  This function returns the vectorized version of a temporal series of 
%  RDMs in the form: [timepoints x vectorizedrdm]

%%  INPUT:
%
%  - rdm : (3D-MATRIX) Representational Dissimilarity Matrices for each
%          timepoint [trials x trials x timepoints]
%
%%  OUTPUT:
%
%  - vrdm : (2D-MATRIX) Vecotized version of a temporal series of RDMs
%           in the form: [timepoints x vectorizedrdm]

%% Remove diagonal and upper triangle:
%  RDMs are square and symmetrical matrices along its diagonal. For
%  computational efficiency both the diagonal and the upper triangle can be
%  removed for each timepoint. The result matrix is [timepoints x values]

parfor tp = 1 : size(rdm,3)
    
    rdm_ = rdm(:,:,tp);
    
    rdm_(logical(eye(size(rdm_)))) = 0;
    vrdm(tp,:) = squareform(rdm_);
    
end

end

