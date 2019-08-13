function [acc_ab,acc_ba,cfg] = mvcc_acc_analysis(cfg,fv)
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing correct rate (MVCC): </strong>\n');
%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) ' >> ']);
    %% Data and true labels:
    tic
    [Xa,Ya,Xb,Yb,cfg] = data_labels(cfg,fv(sub,:));
    
    if cfg.mvcc.parcomp
        %% Timepoints loop - PARALLEL COMPUTING
        c = cfg.mvcc;
        parfor tp = 1 : c.ntp
            % Direction A - B:
            correct_rate_ab(tp,:) = mvcc_svm_classifier(...
                Xa,Ya,Xb,Yb,tp,c,false);
            % Direction B - A:
            correct_rate_ba(tp,:) = mvcc_svm_classifier(...
                Xb,Yb,Xa,Ya,tp,c,false);
        end
    else
        %% Timepoints loop - REGULAR COMPUTING
        for tp = 1 : cfg.mvcc.ntp
            % Direction A - B:
            correct_rate_ab(tp,:) = mvcc_svm_classifier(...
                Xa,Ya,Xb,Yb,tp,cfg.mvcc,false);
            % Direction B - A:
            correct_rate_ba(tp,:) = mvcc_svm_classifier(...
                Xb,Yb,Xa,Ya,tp,cfg.mvcc,false);
        end
    end
    
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

