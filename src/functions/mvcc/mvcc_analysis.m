function [res,cfg] = mvcc_analysis(cfg,fv)
%mvcc_analysis Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing correct rate (MVCC): </strong>\n');
%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    tic; fprintf(['   - Subject: ' int2str(sub) '/' int2str(length(cfg.subjects)) ' >> ']);
    train_X = fv.X{sub}.a; test_X = fv.X{sub}.b;
    train_Y = fv.Y{sub}.a; test_Y = fv.Y{sub}.b;
    
    %% Timepoints loop
    if cfg.analysis.parcomp
        parfor tp = 1 : cfg.analysis.ntp
            % Direction A - B:
            [cr_ab(tp,:), ...
                auc_ab(tp,:),... 
                roc_xcor_ab{tp},...
                roc_ycor_ab{tp},... 
                cm_ab{tp}] = mvcc_classifier(...
                train_X,train_Y,test_X,test_Y,tp,cfg);
            
            % Direction B - A:
            [cr_ba(tp,:), ...
                auc_ba(tp,:),... 
                roc_xcor_ba{tp},...
                roc_ycor_ba{tp},... 
                cm_ba{tp}] = mvcc_classifier(...
                test_X,test_Y,train_X,train_Y,tp,cfg);
        end
    else
        for tp = 1 : cfg.analysis.ntp
            % Direction A - B:
            [cr_ab(tp,:), ...
                auc_ab(tp,:),... 
                roc_xcor_ab{tp},...
                roc_ycor_ab{tp},... 
                cm_ab{tp}] = mvcc_classifier(...
                train_X,train_Y,test_X,test_Y,tp,cfg);
            
            % Direction B - A:
            [cr_ba(tp,:), ...
                auc_ba(tp,:),... 
                roc_xcor_ba{tp},...
                roc_ycor_ba{tp},... 
                cm_ba{tp}] = mvcc_classifier(...
                test_X,test_Y,train_X,train_Y,tp,cfg);
        end
    end
    
    %% Generate data structure for the results:
    
    if isrow(cr_ab) && isrow(cr_ba)
        res.cr.ab(:,:,sub) = cr_ab;
        res.cr.ba(:,:,sub) = cr_ba;
        
        res.auc.ab(:,:,sub) = auc_ab;
        res.auc.ba(:,:,sub) = auc_ba;
        
    else
        res.cr.ab(:,:,sub) = cr_ab';
        res.cr.ba(:,:,sub) = cr_ba';
        
        res.auc.ab(:,:,sub) = auc_ab';
        res.auc.ba(:,:,sub) = auc_ba';
    end
    
    res.x.ab = roc_xcor_ab;
    res.x.ba = roc_xcor_ba;
    res.y.ab = roc_ycor_ab;
    res.y.ba = roc_ycor_ba;
    
    res.cm.ab = cm_ab;
    res.cm.ba = cm_ba;
    
    toc
    
end
fprintf(' - Done!\n');

end

