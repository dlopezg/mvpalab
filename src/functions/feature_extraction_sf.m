function cfg = feature_extraction_sf (cfg)

%% Search folders:
folders = dir([cfg.fe.dir filesep 's_*']);
savedir = cfg.fe.savedir;
fprintf('<strong> > Generating feature vectors </strong>\n');
%% Subjects loop:
for sub = 1 : length(folders)
    folder = [folders(sub).folder filesep folders(sub).name];
    files = dir([folder filesep 'filtered_*.mat']);
    fprintf(['- Subject: ' int2str(sub) '/' int2str(length(folders)) ' - Frequency: ']);
    %% Frequencies loop:
    for freq = 1 : length(files)
        print_counter(freq,length(files));
        file = [files(freq).folder filesep files(freq).name];
        load(file);
        %% Context loop:
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
        
        dirname = [savedir filesep 's_' sprintf('%03d',sub)];
        create_folder(dirname);
        filename = ['fv_' files(freq).name];
        save([dirname filesep filename],'inpvec','cfg');
    end
end
fprintf(' - Done!\n');
end