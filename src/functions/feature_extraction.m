function [ inputvec , cfg, summary ] = feature_extraction ( cfg, classes )
% FEATURE_EXTRACTION This function generates the feature vectors for the
% mvpa classification.
%
% FEATURE_EXTRACTION > Input arguments:
%
% Conditions/classes:
% ------------------------------------------------------------
% Structure with data:      classes > .name_a .name_b ...
%
% Configuration/Actions:
% ------------------------------------------------------------
% Smooth the data:          cfg.fe.smooth > .flag .method .window
% Supertrial generation:    cfg.fe.strial > .flag .ntrials
% Adjust class size (k):    cfg.cv.matchc > .nfolds
% Z-score normalization:    cfg.fe.zscore > .flag
% Match classes sizes:      cfg.fe.matchc > .flag .method
%
% ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% mvpa-toolbox 2019
% David López-García (dlopez@ugr.es)

fprintf('      <strong>> Generating input vectors...</strong>\n');

%% Extract classes

class_names = fieldnames(classes);

%% Classes loop:
for class = 1 : length(class_names)
    fprintf(['       - ' class_names{class} '...\n']);
    data = classes.(class_names{class});
    
    %% Smooth data:
    
    if isfield(cfg.fe,'smooth')
        if cfg.fe.smooth.flag
            data = smoothdata(data,2,cfg.fe.smooth.method,...
                cfg.fe.smooth.window);
        end
    end
    
    %% Average trials if needed:
    
    if isfield(cfg.fe,'strial')
        if cfg.fe.strial.flag
            for i = 1 : floor(size(data,3)/cfg.fe.strial.ntrials)
                idxs = randperm(size(data,3),cfg.fe.strial.ntrials);
                super_trials(:,:,i) = mean(data(:,:,idxs),3);
                data(:,:,idxs) = [];
            end
            data = super_trials; clear super_trials;
        end
    end
    
    %% Adjust class size (factor of k):
    
    if isfield(cfg.fe,'matchc')
        if cfg.fe.matchc.flag
            data = data(:,:,1:floor(size(data,3)/...
                cfg.fe.matchc.nfolds)*cfg.fe.matchc.nfolds);
        end
    end
    
    %% Z-SCORE normalization:
    
    if isfield(cfg.fe,'zscore')
        if cfg.fe.zscore.flag
            data = zscore(data,[],2);
        end
    end
    
    %% Extract features vector for each timepoint and each trial:
    
    inputvec{class} = permute(data,[3 1 2]);
    class_size(class) = size(inputvec{class},1);
    
end

%% Match coditions size by downsampling:
if isfield(cfg.fe,'matchc')
    if cfg.fe.matchc.flag
        [minsize,~] = min(class_size(:));
        for class = 1 : length(class_names)
            inputvec{class} = inputvec{class}(1:minsize,:,:);
        end
    end
end

fprintf(['       - Done!\n\n']);

end