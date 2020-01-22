function [cr,params,cfg] = cr_classifier(X,Y,tp,cfg,strpar)
%SVM_CLASSIFIER This function returns the accuracy of the classifier in a
%time-resolved way.
%% Cross-validation loop:
params = [];
for k = 1 : strpar.NumTestSets
    %% Train and test datasets:
    test_fold = strpar.test(k);
    training_fold = strpar.training(k);
    test_X = X(strpar.test(k),:,cfg.tpoints(tp));
    train_X = X(training_fold,:,cfg.tpoints(tp));
    train_Y = Y(training_fold);
    test_Y = Y(test_fold);
    
    % Permute labels if needed:
    if cfg.permlab
        train_Y = train_Y(randperm(length(train_Y)));
    end
    
    %% Feature selection if needed:
    if cfg.pca.flag || cfg.pls.flag
        [train_X,test_X,params] = ...
            feature_selection(train_X,train_Y,test_X,test_Y,cfg);
    end
    %% Train and test SVM model
    % Hyperparameter optimization if needed:
    if cfg.optimize.flag
        mdlSVM = compact(fitcsvm(train_X,train_Y,...
            'OptimizeHyperparameters',cfg.optimize.params,...
            'HyperparameterOptimizationOptions',cfg.optimize.opt));
    else
        mdlSVM = compact(fitcsvm(train_X,train_Y));
    end
    
    % Test - Temporal generalization matrix if needed:
    if cfg.tempgen
        for tp2 = 1 : cfg.ntp
            test_X = X(test_fold,:,cfg.tpoints(tp2));
            % Project new test set in the PC space if needed
            if cfg.pca.flag; test_X = project_pca(test_X,params,cfg); end
            % Compute correct rate
            acc(k,tp2) = sum(test_Y == predict(mdlSVM,test_X));
        end
    else
        acc(k) = sum(test_Y == predict(mdlSVM,test_X));
    end
end
%% Return correct rate:
cr = mean(acc/length(test_Y));
end