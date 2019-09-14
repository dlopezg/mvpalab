function [ permuted_maps , cfg ] = mvpa_permutation_maps_sf( cfg )
%% Search folders:
folders = dir([cfg.sf.dir filesep 's_*']);
fprintf('<strong> > Generating feature vectors </strong>');

%% Subjects loop:
for sub = 1 : length(folders)
    folder = [folders(sub).folder filesep folders(sub).name];
    files = dir([folder filesep 'fv_filtered_*.mat']);
    
    %% Frequencies loop:
    for freq = 1 : length(files)
        file = [files(freq).folder filesep files(freq).name];
        load(file);
        cfg.analysis = analysis_timming(cfg.analysis);
        %% Data and true labels:
        tic; [X,Y,~,~,cfg] = data_labels(cfg,fv);
        
        %% Feature selection:
        X = feature_selection(cfg,X,Y);
        
        %% Generate permuted labels
        for i = 1 : cfg.analysis.stats.nper
            tic
            strpar = cvpartition(Y,'KFold',cfg.analysis.nfolds);
            c = cfg.analysis;
            if cfg.analysis.parcomp
                %% Timepoints loop
                parfor tp = 1 : cfg.sf.ntp
                    correct_rate(1,tp) = mvpa_svm_classifier(...
                        X,Y,tp,c,strpar,true);
                end
                
                fprintf(['     - Permutation: ' int2str(i) ' > ']);
            else
                for tp = 1 : cfg.sf.ntp
                    correct_rate(1,tp) = mvpa_svm_classifier(...
                        X,Y,tp,c,strpar,true);
                end
                fprintf(['     - Permutation: ' int2str(i) ' > ']);
            end
            
            permuted_maps(freq,:,i,sub) = correct_rate;
            
            toc
        end
        
    end
end

end

