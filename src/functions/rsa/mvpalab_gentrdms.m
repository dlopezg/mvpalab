function trdms = mvpalab_gentrdms(tmodels,bounds)
%% MVPALAB_GENTRDMS
%
%  This function returns theoretical RDMs according to the previously
%  constructed model. To do so, this functions uses the size of each
%  condition included in the boundaries vector to construct the final
%  theoretical RDM.
%
%  INPUT:
%
%  - cfg: (STRUCT) Configuration estructure. 
%
%  - bounds : (STRUCT) - (ARRAY OF INTEGERS) This vector contains the
%             indexes of the last and the middle trial of each condition in
%             the data matrix.
%
%  OUTPUT:
%
%  - trdms : (4D-MATRIX) - Theoretical RDMs [trials x trials x 1 x models].

%% Extract boundaries:
%  This vector includes indexes of the last trial for each condition:

bounds = [1 bounds.last];

%% Theoretical models loop
%  We generate diferent RDMs for each theoretical model:

for i = 1 : size(tmodels,3)
    
    tmodel = tmodels(:,:,i);
    
    %% Generate RDM:
    %  For each cell in the neural RDM we need to asign a one or zero
    %  value according to the theoretical model. The size of the condition
    %  is extracted from the boundaries vector.
    
    for j = 1 : length(bounds)-1
        for k = 1 : length(bounds)-1
            trdms(bounds(j):bounds(j+1),bounds(k):bounds(k+1),1,i) = ...
                tmodel(j,k);
        end
    end
    
end

