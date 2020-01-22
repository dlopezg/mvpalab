function [mvcc_results,cfg] = mvcc_analysis(cfg,fv)
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
        c = cfg.analysis;
        parfor tp = 1 : c.ntp
            % Direction A - B:
            [correct_rate_ab(tp,:), ...
                area_under_curve_ab(tp,:),... 
                roc_xcor_ab{tp},...
                roc_ycor_ab{tp},... 
                confusion_matrix_ab{tp}] = mvcc_classifier(...
                train_X,train_Y,test_X,test_Y,tp,c);
            
            % Direction B - A:
            [correct_rate_ba(tp,:), ...
                area_under_curve_ba(tp,:),... 
                roc_xcor_ba{tp},...
                roc_ycor_ba{tp},... 
                confusion_matrix_ba{tp}] = mvcc_classifier(...
                test_X,test_Y,train_X,train_Y,tp,c);
        end
    else
        for tp = 1 : cfg.analysis.ntp
            % Direction A - B:
            [correct_rate_ab(tp,:), ...
                area_under_curve_ab(tp,:),... 
                roc_xcor_ab{tp},...
                roc_ycor_ab{tp},... 
                confusion_matrix_ab{tp}] = mvcc_classifier(...
                train_X,train_Y,test_X,test_Y,tp,cfg.analysis);
            
            % Direction B - A:
            [correct_rate_ba(tp,:), ...
                area_under_curve_ba(tp,:),... 
                roc_xcor_ba{tp},...
                roc_ycor_ba{tp},... 
                confusion_matrix_ba{tp}] = mvcc_classifier(...
                test_X,test_Y,train_X,train_Y,tp,cfg.analysis);
        end
    end
    
    %% Generate data structure for the results:
    
    if isrow(correct_rate_ab) && isrow(correct_rate_ba)
        mvcc_results.correct_rate.ab(:,:,sub) = correct_rate_ab;
        mvcc_results.correct_rate.ba(:,:,sub) = correct_rate_ba;
        
        mvcc_results.area_under_curve.ab(:,:,sub) = area_under_curve_ab;
        mvcc_results.area_under_curve.ba(:,:,sub) = area_under_curve_ba;
        
    else
        mvcc_results.correct_rate.ab(:,:,sub) = correct_rate_ab';
        mvcc_results.correct_rate.ba(:,:,sub) = correct_rate_ba';
        
        mvcc_results.area_under_curve.ab(:,:,sub) = area_under_curve_ab';
        mvcc_results.area_under_curve.ba(:,:,sub) = area_under_curve_ba';
    end
    
    mvcc_results.roc_xcor.ab = roc_xcor_ab;
    mvcc_results.roc_xcor.ba = roc_xcor_ba;
    mvcc_results.roc_ycor.ab = roc_ycor_ab;
    mvcc_results.roc_ycor.ba = roc_ycor_ba;
    
    mvcc_results.confusion_matrix.ab = confusion_matrix_ab;
    mvcc_results.confusion_matrix.ba = confusion_matrix_ba;
    
    toc
    
end
fprintf(' - Done!\n');

end

