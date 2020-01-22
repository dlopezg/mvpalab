function [ out_data,cfg] = feature_extraction ( cfg, sub_data )
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
% Adjust class size (k):    cfg.fe.matchc > .nfolds
% Z-score normalization:    cfg.fe.zscore > .flag
% Match classes sizes:      cfg.fe.matchc > .flag .method
% MVCC extraction:          cfg.fe.mvccex > .flag

% ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% mvpa-toolbox 2019
% David López-García (dlopez@ugr.es)
% Brain, Mind and Behavioral Research Center - University of Granada.

fprintf('<strong> > Generating feature vectors </strong>');
fprintf('- Subject: ');

%% Initialize:
X = cell(length(cfg.subjects),1);
Y = X;

%% Subject loop:
for sub = 1 : length(cfg.subjects)
    
    %% Context loop:
    for ctxt = 1 : size(sub_data,2)
        %% Extract classes:
        classes = sub_data{sub,ctxt};
        class_names = fieldnames(classes);
        
        %% Classes loop:
        for class = 1 : length(class_names)
            data = classes.(class_names{class});
            fv{ctxt,class} = preproc_data(cfg,data);
            class_size(ctxt,class) = size(fv{ctxt,class},1);
        end
        
    end
    
    %% Match coditions size by downsampling:
    if cfg.fe.matchc.flag
        minsize = min(min(class_size));
        c = 1;
        for ctxt = 1 : size(fv,1)
            for class = 1 : size(fv,2)
                inpvec{sub,c} = fv{ctxt,class}(1:minsize,:,:);
                c = c + 1;
            end
        end
    else
        inpvec{sub,c} = fv{ctxt,class};
    end
    
    %% Data and labels:
    [X{sub},Y{sub},cfg] = data_labels(cfg,inpvec(sub,:));
    out_data.X = X; 
    out_data.Y = Y;
    
    %% Print subject counter:
    print_counter(sub,length(cfg.subjects));
end
fprintf(' - Done!\n');
end