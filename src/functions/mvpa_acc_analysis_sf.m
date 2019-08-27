function [acc,cfg] = mvpa_acc_analysis_sf(cfg)
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing correct rate: </strong>\n');
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
        %% Data and true labels:
        tic
        [X,Y,~,~,cfg] = data_labels(cfg,inpvec);
        
        %% Train and test de classifier with original labels:
        strpar = cvpartition(Y,'KFold',cfg.mvpa.nfolds);
        
        if cfg.mvpa.parcomp
            %% Timepoints loop
            c = cfg.mvpa;
            parfor tp = 1 : c.ntp
                acc(freq,tp,sub) = mvpa_svm_classifier(X,Y,tp,c,strpar,false);
            end
        else
            for tp = 1 : cfg.mvpa.ntp
                acc(freq,tp,sub) = mvpa_svm_classifier(X,Y,tp,cfg.mvpa,strpar,false);
            end
        end
        toc
    end
    
end
fprintf(' - Done!\n');
end

