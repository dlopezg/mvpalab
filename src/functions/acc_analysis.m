function [ acc ] = acc_analysis( cfg, fv )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing correct rate: </strong>\n');


%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) ' >> ']);
    %% Data and true labels:
    tic
    class_a = fv{sub,1};
    class_b = fv{sub,2};
    
    size_a = size(class_a,1);
    size_b = size(class_b,1);
    
    X = [class_a;class_b];
    Y = logical([zeros(size_a,1);ones(size_b,1)]);
    
    %% Train and test de classifier with original labels:
    strpar = cvpartition(Y,'KFold',cfg.mvpa.nfolds);
    
    if cfg.mvpa.parcomp
        %% Timepoints loop
        c = cfg.mvpa;
        parfor tp = 1 : c.ntp
            correct_rate(tp,:) = svm_classifier_2(X,Y,c,strpar,tp);
        end
    else
        for tp = 1 : cfg.mvpa.ntp
            correct_rate(tp,:) = svm_classifier_2(X,Y,cfg.mvpa,strpar,tp);
        end
    end
    
    if isrow(correct_rate)
        acc(:,:,sub) = correct_rate;
    else
        acc(:,:,sub) = correct_rate';
    end
    
    %% Print subject counter:
    toc
    
end
fprintf(' - Done!\n');
end

