function betas = mvpalab_loadbetas(cfg)
%% MVPALAB_LOADBETAS
%
%  This function returns the Representational Dissimilarity Matrices for
%  in a time resolved way.
%

%% Load SMP file and regressors names:

load(fullfile(cfg.study.SPMFolder,'SPM.mat'));

%% Extract beta files and info:

all_betas = SPM.Vbeta;
betas_fname = extractfield(all_betas,'fname');
betas_descrip = extractfield(all_betas,'descrip');

%% Import the required beta files:

for i = 1 : length(cfg.study.conditionIdentifier)
    
    % Extract regressor name:
    regressor_name = cfg.study.conditionIdentifier{1,i};
    idxs = contains(betas_descrip,regressor_name);
    
    % Generate files to load:
    files_to_load = fullfile(cfg.study.SPMFolder,betas_fname(idxs))';
    
    for f = 1 : length(files_to_load)
        betas{i,f} = mvpalab_readnifti(files_to_load{f});
    end
    
end

end

