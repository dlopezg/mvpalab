function [ acc ,cfg ] = mvpa_acc_analysis( cfg, fv, permute )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing correct rate: </strong>\n');
%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) ' >> ']);
    %% Data and true labels:
    tic; [X,Y,~,~,cfg] = data_labels(cfg,fv(sub,:));
    
    %% Stratified partition for cross validation:
    strpar = cvpartition(Y,'KFold',cfg.analysis.nfolds);
    
    %% Feature selection:
     X = feature_selection(cfg,X,Y);
    
     %% Timepoints loop
    if cfg.analysis.parcomp
        c = cfg.analysis;
        parfor tp = 1 : c.ntp
            correct_rate(tp,:) = mvpa_svm_classifier(X,Y,tp,c,strpar,permute);
        end
    else
        for tp = 1 : cfg.analysis.ntp
            correct_rate(tp,:) = mvpa_svm_classifier(X,Y,tp,cfg.analysis,strpar,permute);
        end
    end
    
    
    if isrow(correct_rate)
        acc(:,:,sub) = correct_rate;
    else
        acc(:,:,sub) = correct_rate';
    end
    
    toc
    
end
fprintf(' - Done!\n');
end

