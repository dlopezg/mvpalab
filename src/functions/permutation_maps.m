function [ permuted_maps ] = permutation_maps( cfg, fv )
%PERMUTATION_MAPS This function generates permutation maps at a subject
%level for future statistical analyses.
fprintf('<strong> > Computing permutated maps: </strong>\n');

%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) '\n']);
    %% Data and true labels:
    class_a = fv{sub,1};
    class_b = fv{sub,2};
    
    size_a = size(class_a,1);
    size_b = size(class_b,1);
    
    X = [class_a;class_b];
    Y = logical([zeros(size_a,1);ones(size_b,1)]);
    
    %% Generate permuted labels
    per_Y = repmat(Y,1,cfg.stats.nper);
    
    for i = 1 : cfg.stats.nper
        per_Y(:,i) = Y(randperm(length(Y)));
    end
    
    %% Train and test de classifier with permuted labels:
    for i = 1 : cfg.stats.nper
        tic
        strpar = cvpartition(Y,'KFold',cfg.mvpa.nfolds);
        
        if cfg.mvpa.parcomp
            %% Timepoints loop
            Y = per_Y(:,i);
            c = cfg.mvpa;
            parfor tp = 1 : cfg.mvpa.ntp
                correct_rate(tp,:) = svm_classifier_2(X,Y,c,strpar,tp);
            end
            
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        else
            for tp = 1 : cfg.mvpa.ntp
                correct_rate(tp,:) = svm_classifier_2(X,Y,cfg.mvpa,strpar,tp);
            end
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        end
        
        if isrow(correct_rate)
            permuted_maps(:,:,i,sub) = correct_rate;
        else
            permuted_maps(:,:,i,sub) = correct_rate';
        end
        
        toc
    end
end

end

