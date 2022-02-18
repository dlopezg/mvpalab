function vrdm = mvpalab_vectorizerdm(cfg,rdm)
%% MVPALAB_VECTORIZERDM
%
%  This function returns the vectorized version of a temporal series of 
%  RDMs in the form: [timepoints x vectorizedrdm]

%%  INPUT:
%
%  - cfg: (STRUCT) Configuration estructure. 
%
%  - rdm : (4D-MATRIX) Representational Dissimilarity Matrices for each
%          timepoint and model [trials x trials x timepoints x model]
%
%%  OUTPUT:
%
%  - vrdm : (3D-MATRIX) Vecotized version of a temporal series of RDMs
%           in the form: [timepoints x vectorizedrdm x models]

%% Remove diagonal and upper triangle:
%  RDMs are square and symmetrical matrices along its diagonal. For
%  computational efficiency both the diagonal and the upper triangle can be
%  removed for each timepoint. 
% The result matrix is [timepoints x values x models]

for mdl = 1 : size(rdm,4)
    parfor tp = 1 : size(rdm,3)
        
        rdm_ = rdm(:,:,tp,mdl);
        
        rdm_(logical(eye(size(rdm_)))) = 0;
        vrdm(tp,:,mdl) = squareform(rdm_);
    end
end

%% Repmat models:
%  For data structure consistency the theoretical models must be repeated
%  for each timepoint:

if size(rdm,3) == 1
   vrdm = repmat(vrdm(1,:,:),[cfg.tm.ntp 1 1]); 
end

end

