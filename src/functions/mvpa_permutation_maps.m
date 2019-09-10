function [ permuted_maps , cfg ] = mvpa_permutation_maps( cfg, fv )
%PERMUTATION_MAPS This function generates permutation maps at a subject
%level for future statistical analyses.
fprintf('<strong> > Computing permutated maps: </strong>\n');

%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) '\n']);
    %% Data and true labels:
    tic
    [X,Y,~,~,cfg] = data_labels(cfg,fv(sub,:));
    
    %% Generate permuted labels
    for i = 1 : cfg.stats.nper
        tic
        strpar = cvpartition(Y,'KFold',cfg.analysis.nfolds);
        if cfg.analysis.parcomp
            %% Timepoints loop
            c = cfg.analysis;
            parfor tp = 1 : cfg.analysis.ntp
                correct_rate(tp,:) = mvpa_svm_classifier(...
                    X,Y,tp,c,strpar,true);
            end
            
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        else
            for tp = 1 : cfg.analysis.ntp
                correct_rate(tp,:) = mvpa_svm_classifier(...
                    X,Y,tp,c,strpar,true);
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

