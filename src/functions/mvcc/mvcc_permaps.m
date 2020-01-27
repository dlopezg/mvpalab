function [permaps,cfg] = mvcc_permaps(cfg,fv)
%PERMUTATION_MAPS This function generates permutation maps at a subject
%level for future statistical analyses.
fprintf('<strong> > Computing permutated maps (MVCC): </strong>\n');
cfg.analysis.permlab = true;
%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(length(cfg.subjects)) '\n']);
    train_X = fv.X{sub}.a; test_X = fv.X{sub}.b; 
    train_Y = fv.Y{sub}.a; test_Y = fv.Y{sub}.b;
    
    %% Generate permuted labels
    for i = 1 : cfg.stats.nper
        tic;
        if cfg.analysis.parcomp
            %% Timepoints loop
            parfor tp = 1 : cfg.analysis.ntp
                % Direction A - B:
                [correct_rate_ab(tp,:), ...
                    area_under_curve_ab(tp,:),...
                    roc_xcor_ab{tp},...
                    roc_ycor_ab{tp},...
                    confusion_matrix_ab{tp}] = mvcc_classifier(...
                    train_X,train_Y,test_X,test_Y,tp,cfg);
                
                % Direction B - A:
                [correct_rate_ba(tp,:), ...
                    area_under_curve_ba(tp,:),...
                    roc_xcor_ba{tp},...
                    roc_ycor_ba{tp},...
                    confusion_matrix_ba{tp}] = mvcc_classifier(...
                    test_X,test_Y,train_X,train_Y,tp,cfg);
            end
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        else
            for tp = 1 : cfg.analysis.ntp
                % Direction A - B:
                [correct_rate_ab(tp,:), ...
                    area_under_curve_ab(tp,:),...
                    roc_xcor_ab{tp},...
                    roc_ycor_ab{tp},...
                    confusion_matrix_ab{tp}] = mvcc_classifier(...
                    train_X,train_Y,test_X,test_Y,tp,cfg);
                
                % Direction B - A:
                [correct_rate_ba(tp,:), ...
                    area_under_curve_ba(tp,:),...
                    roc_xcor_ba{tp},...
                    roc_ycor_ba{tp},...
                    confusion_matrix_ba{tp}] = mvcc_classifier(...
                    test_X,test_Y,train_X,train_Y,tp,cfg);
            end
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        end
        
        if isrow(correct_rate_ab) && isrow(correct_rate_ba)
            permaps.correct_rate.ab(:,:,i,sub) = correct_rate_ab;
            permaps.correct_rate.ba(:,:,i,sub) = correct_rate_ba;
            
            permaps.area_under_curve.ab(:,:,i,sub) = area_under_curve_ab;
            permaps.area_under_curve.ba(:,:,i,sub) = area_under_curve_ba;
            
        else
            permaps.correct_rate.ab(:,:,i,sub) = correct_rate_ab';
            permaps.correct_rate.ba(:,:,i,sub) = correct_rate_ba';
            
            permaps.area_under_curve.ab(:,:,i,sub) = area_under_curve_ab';
            permaps.area_under_curve.ba(:,:,i,sub) = area_under_curve_ba';
        end
        toc
    end
end
cfg.analysis.permlab = false;
end

