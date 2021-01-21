function [ out_data,cfg] = mvpalab_fext ( cfg, data, sub )
% FEATURE_EXTRACTION This function generates the feature vectors.
%% Initialize:
X = cell(length(cfg.study.dataFiles{1,1}),1);
Y = X;

%% Match class size (factor of k) is not needed for MVCC:
if size(data) > 1
    cfg.classize.matchkfold = false;
end

%% Context loop:
for ctxt = 1 : size(data,2)
    % Extract classes:
    classes = data{ctxt};
    class_names = fieldnames(classes);
    
    %% Classes loop:
    for class = 1 : length(class_names)
        fprintf('\n    <strong> - Generating feature vectors:</strong>\n');
        data_ = classes.(class_names{class});
        
        % Power envelope as a feature if needed:
        if isfield(cfg.fext,'feature') && strcmp(cfg.fext.feature,'envelope')
           [cfg, data_] = mvpalab_powenvelope(cfg,data_);
        end
        
        fv{ctxt,class} = mvpalab_preproc(cfg,data_);
        class_size(ctxt,class) = size(fv{ctxt,class},1);
    end
end

%% Match coditions size by downsampling:
c = 1;
for ctxt = 1 : size(fv,1)
    minsize = min(class_size(ctxt,:));
    for class = 1 : size(fv,2)
        if cfg.classize.match
            inpvec{1,c} = fv{ctxt,class}(1:minsize,:,:);
        else
            inpvec{1,c} = fv{ctxt,class};
        end
        cfg.datalength(sub,c) = size(inpvec{1,c},1);
        c = c + 1;
    end
end


%% Data and labels:
[X,Y,cfg] = mvpalab_datalabels(cfg,inpvec);
out_data.X = X;
out_data.Y = Y;

fprintf('\n');

end