function trdms = mvpalab_gentrdms(cfg,mdls,bounds)
%% MVPALAB_GENTRDMS
%
%  This function returns theoretical RDMs according to the previously
%  constructed model. To do so, this functions uses the size of each
%  condition included in the boundaries vector to construct the final
%  theoretical RDM.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Description: Configuration structure.
%
%  - {cellarray} mdls
%    Description: Cells contain a data structure for each theoretical model
%    including the following fields:
%
%       - {string} id : Identifier of the model.
%       - {matrix} mdl: Data matrix of the model. - [ncond x ncond]
%
%  - {array} bounds
%    Description: This vector contains the indexes of the last trial of
%    each condition in the data matrix. - [trials x trials]
%
%%  OUTPUT:
%
%  - {4D-matrix} trdms
%    Description: Theoretical RDMs [trials x trials x 1 x models].

fprintf('     <strong>- Computing theoretical RDMs:</strong>\n');

%% Analysis type:
%  If the analysis is computed condition-by-condition is not necessary to
%  generate the theoretical models because they are already specified:

if ~cfg.rsa.trialwise
    for i = 1 : length(mdls)
        trdms(:,:,1,i) = cfg.rsa.tmodels{i}.mdl;
    end
    return
end

%% Extract boundaries:
%  This vector includes indexes of the last trial for each condition:

bounds = [1 bounds.last];

%% Theoretical models loop
%  Generate different RDMs for each theoretical model:

for i = 1 : length(mdls)
    %% Generate RDM:
    %  For each cell in the neural RDM we need to asign a one or zero
    %  value according to the theoretical model. The size of the condition
    %  is extracted from the boundaries vector.
    
    fprintf(['        # Model: ' cfg.rsa.tmodels{i}.id '... ']);
    
    for j = 1 : length(bounds)-1
        for k = 1 : length(bounds)-1
            trdms(bounds(j):bounds(j+1),bounds(k):bounds(k+1),1,i) = ...
                mdls{i}.mdl(j,k);
        end
    end
    
    fprintf('- Done.\n');
end



