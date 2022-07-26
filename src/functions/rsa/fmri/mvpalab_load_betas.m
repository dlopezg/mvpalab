function betas = mvpalab_load_betas(folder,conditions_to_extract)
%% MVPALAB_LOADBETAS
%

load(fullfile(folder,'SPM.mat'));

%% Extract beta files and info:
all_betas = SPM.Vbeta;
betas_fname = extractfield(all_betas,'fname');
betas_descrip = extractfield(all_betas,'descrip');

%% Import the required beta files:
for cond = 1 : length(conditions_to_extract)
    
    % Extract regressor name:
    regressor_name = conditions_to_extract{cond};
    idxs = contains(betas_descrip,regressor_name);
    
    % Generate files to losad:
    files_to_load = fullfile(folder,betas_fname(idxs))';
    
    for file = 1 : length(files_to_load)
        betas{cond,file} = mvpalab_read_nifti(files_to_load{file});
    end
    
end

end

