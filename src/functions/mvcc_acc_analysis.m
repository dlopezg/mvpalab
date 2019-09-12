function [acc_ab,acc_ba,cfg] = mvcc_acc_analysis(cfg,fv)
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing correct rate (MVCC): </strong>\n');
%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) ' >> ']);
    %% Data and true labels:
    tic; [Xa,Ya,Xb,Yb,cfg] = data_labels(cfg,fv(sub,:));
    
    %% Feature selection:
    Xa = feature_selection(cfg,Xa,Ya);
    Xb = feature_selection(cfg,Xb,Yb);
    
    %% Timepoints loop
    if cfg.analysis.parcomp
        c = cfg.analysis;
        parfor tp = 1 : c.ntp
            % Direction A - B:
            correct_rate_ab(tp,:) = mvcc_svm_classifier(...
                Xa,Ya,Xb,Yb,tp,c,false);
            % Direction B - A:
            correct_rate_ba(tp,:) = mvcc_svm_classifier(...
                Xb,Yb,Xa,Ya,tp,c,false);
        end
    else
        for tp = 1 : cfg.analysis.ntp
            % Direction A - B:
            correct_rate_ab(tp,:) = mvcc_svm_classifier(...
                Xa,Ya,Xb,Yb,tp,cfg.mvcc,false);
            % Direction B - A:
            correct_rate_ba(tp,:) = mvcc_svm_classifier(...
                Xb,Yb,Xa,Ya,tp,cfg.mvcc,false);
        end
    end
    
    %% ACC
    if isrow(correct_rate_ab) && isrow(correct_rate_ba)
        acc_ab(:,:,sub) = correct_rate_ab;
        acc_ba(:,:,sub) = correct_rate_ba;
    else
        acc_ab(:,:,sub) = correct_rate_ab';
        acc_ba(:,:,sub) = correct_rate_ba';
    end
    
    toc
    
end
fprintf(' - Done!\n');

end

