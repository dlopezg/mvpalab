function [ correct_rate, cfg] = mvpa_svm_classifier(X,Y,tp,cfg,strpar,permute)
%SVM_CLASSIFIER This function returns the accuracy of the classifier in a
%time-resolved way.

if cfg.analysis.roc.flag
    %% Optimization configuration:
    if cfg.optimize.flag
        mdlSVM = compact(fitcsvm(X,Y,...
            'OptimizeHyperparameters',cfg.optimize.params,...
            'HyperparameterOptimizationOptions',cfg.optimize.opt));
    else
        mdlSVM = compact(fitcsvm(X,Y));
    end
    
    %% Stratified cross-validation
    mdlCVSVM = crossval(mdlSVM,'CVPartition',strpar);
    correct_rate(sub,idxx,freq) = 1 - kfoldLoss(mdlCVSVM);
    %     w{sub,idxx,freq} = mdlSVM.Beta;
    
    %% Receiver operating characteristic (ROC curve)
    mdlSVM = fitPosterior(mdlSVM);
    [~,svmscores] = resubPredict(mdlSVM);
    [x,y,t,auc] = perfcurve(Y,svmscores(:,mdlSVM.ClassNames),'true');
    % plot(x{idxx},y{idxx})
else
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
        %% Optimization configuration:
        if cfg.optimize.flag
            mdlSVM = compact(fitcsvm(train_X,train_Y,...
                'OptimizeHyperparameters',cfg.optimize.params,...
                'HyperparameterOptimizationOptions',cfg.optimize.opt));
        else
            mdlSVM = compact(fitcsvm(train_X,train_Y));
        end
        
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


end