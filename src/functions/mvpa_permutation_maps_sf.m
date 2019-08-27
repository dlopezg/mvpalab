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
        load('L:\Matlab\Experiments\EEG_Effort_Choice\analysis\mvpa\times.mat');
        cfg.mvpa.times = time;
        cfg.mvpa = analysis_timming(cfg.mvpa);
        cfg.mvpa.tempgen = false;
        cfg.stats.nper = 10;
        fv = inpvec;
        %% Data and true labels:
        tic
        [X,Y,~,~,cfg] = data_labels(cfg,fv);
        
        %% Generate permuted labels
        for i = 1 : cfg.sf.stats.nper
            tic
            strpar = cvpartition(Y,'KFold',cfg.mvpa.nfolds);
            if cfg.mvpa.parcomp
                %% Timepoints loop
                c = cfg.mvpa;
                parfor tp = 1 : cfg.mvpa.ntp
                    correct_rate(1,tp) = mvpa_svm_classifier(...
                        X,Y,tp,c,strpar,true);
                end
                
                fprintf(['     - Permutation: ' int2str(i) ' > ']);
            else
                for tp = 1 : cfg.mvpa.ntp
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

