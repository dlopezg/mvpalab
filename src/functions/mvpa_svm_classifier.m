function [ correct_rate, cfg] = mvpa_svm_classifier(X,Y,tp,cfg,strpar,permute)
%SVM_CLASSIFIER This function returns the accuracy of the classifier in a
%time-resolved way.

%% Cross-validation loop:
for k = 1 : strpar.NumTestSets
    %% Train and test datasets:
    test_fold = strpar.test(k);
    training_fold = strpar.training(k);
    test_X = X(strpar.test(k),:,cfg.tpoints(tp));
    train_X = X(training_fold,:,cfg.tpoints(tp));
    train_Y = Y(training_fold);
    test_Y = Y(test_fold);
    
    if permute
        train_Y = train_Y(randperm(length(train_Y)));
    end
    
    %% Train SVM model
    mdlSVM = compact(fitcsvm(train_X,train_Y));
    
    %% Test - Temporal generalization matrix:
    
    if cfg.tempgen
        for tp2 = 1 : cfg.ntp
            test_X = X(test_fold,:,cfg.tpoints(tp2));
            acc(k,tp2) = sum(test_Y == predict(mdlSVM,test_X));
        end
        
    else
        acc(k) = sum(test_Y == predict(mdlSVM,test_X));
    end
end

%% Return correct rate:

correct_rate = mean(acc/length(test_Y));

end