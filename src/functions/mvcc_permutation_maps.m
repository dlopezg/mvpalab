function [ permuted_maps_ab,permuted_maps_ba,cfg] = mvcc_permutation_maps(cfg,fv)
%PERMUTATION_MAPS This function generates permutation maps at a subject
%level for future statistical analyses.
fprintf('<strong> > Computing permutated maps (MVCC): </strong>\n');

%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) '\n']);
    %% Data and true labels:
    [Xa,Ya,Xb,Yb,cfg] = data_labels(cfg,fv(sub,:));
    
    %% Feature selection:
    Xa = feature_selection(cfg,Xa,Ya);
    Xb = feature_selection(cfg,Xb,Yb);
    
    %% Generate permuted labels
    for i = 1 : cfg.stats.nper
        tic
        if cfg.analysis.parcomp
            %% Timepoints loop
            c = cfg.analysis;
            parfor tp = 1 : cfg.analysis.ntp
                % Direction A - B:
                correct_rate_ab(tp,:) = mvcc_svm_classifier(...
                    Xa,Ya,Xb,Yb,tp,c,true);
                % Direction B - A:
                correct_rate_ba(tp,:) = mvcc_svm_classifier(...
                    Xb,Yb,Xa,Ya,tp,c,true);
            end
            
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        else
            for tp = 1 : cfg.mvcc.ntp
                % Direction A - B:
                correct_rate_ab(tp,:) = mvcc_svm_classifier(...
                    Xa,Ya,Xb,Yb,tp,c,true);
                % Direction B - A:
                correct_rate_ba(tp,:) = mvcc_svm_classifier(...
                    Xb,Yb,Xa,Ya,tp,c,true);
            end
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        end
        
        if isrow(correct_rate_ab) && isrow(correct_rate_ba)
            permuted_maps_ab(:,:,i,sub) = correct_rate_ab;
            permuted_maps_ba(:,:,i,sub) = correct_rate_ba;
        else
            permuted_maps_ab(:,:,i,sub) = correct_rate_ab';
            permuted_maps_ba(:,:,i,sub) = correct_rate_ba';
            
        end
        toc
    end
end

end

