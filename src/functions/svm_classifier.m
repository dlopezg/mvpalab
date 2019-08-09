function [ correct_rate, cfg] = svm_classifier( X, Y, cfg )
%SVM_CLASSIFIER This function returns the accuracy of the classifier in a
%time-resolved way.
strpar = cvpartition(Y,'KFold',cfg.nfolds);

%% Timepoints loop:
fprintf('       - Timepoints: ');
n = numel(num2str(cfg.ntp)) + 1;

%% Timepoints loop

for tp = 1 : cfg.ntp
    cp{tp} = classperf(Y);
    
    %% Cross-validation loop:
    for k = 1 : strpar.NumTestSets
        %% Train and test datasets:
        test_fold = strpar.test(k);
        training_fold = strpar.training(k);
        test_X = X(strpar.test(k),:,cfg.tpoints(tp));
        train_X = X(training_fold,:,cfg.tpoints(tp));
        train_Y = Y(training_fold);
        test_Y = Y(test_fold);
        l = length(test_Y);
        
        %% Train SVM model
        mdlSVM = compact(fitcsvm(train_X,train_Y));
        
        %% Test - Temporal generalization matrix:
        if cfg.tempgen
            for tp2 = 1 : cfg.ntp
                test_X = X(test_fold,:,cfg.tpoints(tp2));
                predictedlabels = predict(mdlSVM,test_X);
                acc(k,tp2) = sum(test_Y == predictedlabels);
%                 cpmtx{tp,tp2} = classperf(cpmtx{tp,tp2},predictedlabels,test_fold);
%                 correct_rate(tp,tp2) = cpmtx{tp,tp2}.CorrectRate;
            end
            
        else
            predictedlabels = predict(mdlSVM,test_X);
            acc(k) = sum(test_Y == predictedlabels);
%             classperf(cp{tp},predictedlabels,strpar.test(k));
%             correct_rate(tp) = cp{tp}.CorrectRate;
        end
    end
    
    if cfg.tempgen
        correct_rate(tp,:) = mean(acc/l);
    else
        correct_rate(1,tp) = mean(acc/l);
    end
    
    %% Print state:
    if tp > 1
        for j = 0 : log10(tp-1) + n
            fprintf('\b'); % delete previous counter display
        end
    end
    
    fprintf([int2str(cfg.ntp) '/' int2str(tp)]);
end
end

