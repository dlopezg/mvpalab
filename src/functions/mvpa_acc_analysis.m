function [ acc ,cfg ] = mvpa_acc_analysis( cfg, fv, permute )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing correct rate: </strong>\n');
%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) ' >> ']);
    %% Data and true labels:
    tic
    [X,Y,~,~,cfg] = data_labels(cfg,fv(sub,:));
    
    %% Train and test de classifier with original labels:
    strpar = cvpartition(Y,'KFold',cfg.mvpa.nfolds);
    
    if cfg.mvpa.parcomp
        %% Timepoints loop
        c = cfg.mvpa;
        parfor tp = 1 : c.ntp
            correct_rate(tp,:) = mvpa_svm_classifier(X,Y,tp,c,strpar,permute);
        end
    else
        for tp = 1 : cfg.mvpa.ntp
            correct_rate(tp,:) = mvpa_svm_classifier(X,Y,tp,cfg.mvpa,strpar,permute);
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

