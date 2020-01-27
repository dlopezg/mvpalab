function [correct_rate, area_under_curve, roc_xcor, roc_ycor, confusion_matrix, cfg] = mvcc_classifier(train_X,train_Y,test_X,test_Y,tp,cfg)
%MVCC_SVM_CLASSIFIER Summary of this function goes here
%   Detailed explanation goes here

%% Train and test datasets:
train_X_tp = train_X(:,:,cfg.analysis.tpoints(tp));
test_X_tp = test_X(:,:,cfg.analysis.tpoints(tp));

% Data normalization if needed:
if cfg.fe.zscore.flag && cfg.fe.zscore.dim == 3
    train_X_tp = zscore(train_X_tp,[],1);
    test_X_tp = zscore(test_X_tp,[],1);
end

% Permute labels if needed:
if cfg.analysis.permlab
    train_Y = train_Y(randperm(length(train_Y)));
end

%% Feature selection if needed:
if cfg.analysis.pca.flag || cfg.analysis.pls.flag
    [train_X_tp,test_X_tp,params] = ...
        feature_selection(train_X_tp,train_Y,test_X_tp,test_Y,cfg);
end

%% Train and test SVM model
% Hyperparameter optimization if needed:
if cfg.analysis.optimize.flag
    mdlSVM = compact(fitcsvm(train_X_tp,train_Y,...
        'OptimizeHyperparameters',cfg.analysis.optimize.params,...
        'HyperparameterOptimizationOptions',cfg.analysis.optimize.opt));
else
    mdlSVM = compact(fitcsvm(train_X_tp,train_Y));
end

% Temporal generalization if needed:
if cfg.analysis.tempgen
    
    % Preallocating variables for better performance:
    roc_xcor = cell(1,cfg.analysis.ntp);
    roc_ycor = cell(1,cfg.analysis.ntp);
    confusion_matrix = cell(1,cfg.analysis.ntp);
    correct_rate = zeros(1,cfg.analysis.ntp);
    area_under_curve = zeros(1,cfg.analysis.ntp);
    
    
    for tp2 = 1 : cfg.analysis.ntp
        test_X_tp2 = test_X(:,:,cfg.analysis.tpoints(tp2));
        
        % Project new test set in the PC space if needed
        if cfg.analysis.pca.flag 
            test_X_tp2 = project_pca(test_X_tp2,params,cfg);
        end
        
        % Predict labels:
        [predicted_labels,predicted_scores] = predict(mdlSVM,test_X_tp2);
        
        % Compute confusion matrix:
        confusion_matrix{tp2} = confusionmat(test_Y,predicted_labels);
        
        % Receiver operating characteristic (ROC curve)
        [roc_xcor{tp2},roc_ycor{tp2},~,area_under_curve(tp2)] = ...
            perfcurve(test_Y,predicted_scores(:,mdlSVM.ClassNames),1);
        
        % Compute correct rate:
        correct_rate(tp2) = sum(test_Y == predicted_labels)/length(test_Y);
        
    end
else
    % Predict labels:
    [predicted_labels,predicted_scores] = predict(mdlSVM,test_X_tp);
    
    % Compute confusion matrix:
    confusion_matrix = confusionmat(test_Y,predicted_labels);
    
    % Receiver operating characteristic (ROC curve)
    [roc_xcor,roc_ycor,~,area_under_curve] = ... 
        perfcurve(test_Y,predicted_scores(:,mdlSVM.ClassNames),1);
    
    % Compute correct rate:
    correct_rate = sum(test_Y == predicted_labels)/length(test_Y);
end


%% Antiguo:
%% Calculate acc:
% if cfg.analysis.tempgen
%     for tp2 = 1 : cfg.analysis.ntp
%         test_X_tp2 = test_X(:,:,cfg.analysis.tpoints(tp2));
%         % Project new test set in the PC space if needed
%         if cfg.analysis.pca.flag; test_X_tp2 = project_pca(test_X_tp2,p,cfg); end
%         % Compute correct rate
%         predicted_labels = predict(mdlSVM,test_X_tp2);
%         cr(tp2) = sum(test_Y == predicted_labels);
%     end
% else
%     predicted_labels = predict(mdlSVM,test_X_tp);
%     cr = sum(test_Y == predicted_labels);
% end
% 
% cr = cr/length(test_Y);

end

