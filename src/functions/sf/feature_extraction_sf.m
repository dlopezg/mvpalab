function [cfg,inpvec] = feature_extraction_sf (cfg,data)
for ctxt = 1 : size(data,2)
    %% Extract classes:
    classes = data{ctxt};
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
            inpvec{c} = fv{ctxt,class}(1:minsize,:,:);
            c = c + 1;
        end
    end
else
    inpvec{c} = fv{ctxt,class};
end
fprintf(' - Done!\n');
end