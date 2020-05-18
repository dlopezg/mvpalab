function [x,y,auc,cr,cm,w] = mvpalab_mvcceval(X,train_Y,Xt,test_Y,tp,cfg)
%MVCC_SVM_CLASSIFIER Summary of this function goes here
%   Detailed explanation goes here

x = {}; y = {}; auc = NaN; cr = NaN; cm = {}; w = [];

%% Train and test datasets:
train_X = X(:,:,cfg.tm.tpoints(tp));
test_X = Xt(:,:,cfg.tm.tpoints(tp));

%% Data normalization if needed:
[train_X,test_X,nparams] = mvpalab_datanorm(cfg,train_X,test_X,[]);

%% Permute labels if needed:
if cfg.classmodel.permlab
    train_Y = train_Y(randperm(length(train_Y)));
end

%% Feature selection if needed:
if cfg.fsel.flag
    [train_X,test_X,params] = ...
        mvpalab_fsel(train_X,train_Y,test_X,test_Y,cfg);
end

%% Train and test the model:
[mdl,w] = mvpalab_train(train_X,train_Y,cfg);


%% Temporal generalization if needed:
if cfg.classmodel.tempgen
    
    % Preallocating variables for better performance:
    x = cell(1,cfg.tm.ntp);
    y = cell(1,cfg.tm.ntp);
    cm = cell(1,cfg.tm.ntp);
    cr = zeros(1,cfg.tm.ntp);
    auc = zeros(1,cfg.tm.ntp);
    
    for tp_ = 1 : cfg.tm.ntp
        
        % Update test set for the actual timepoint:
        test_X = Xt(:,:,cfg.tm.tpoints(tp_));
        
        % Data normalization if needed:
        [~,test_X,nparams] = mvpalab_datanorm(cfg,[],test_X,nparams);
        
        % Project new test set in the PC space if needed:
        if cfg.fsel.flag
            test_X = mvpalab_project(test_X,params,cfg);
        end
        
        % Predict labels and scores:
        [labels,scores] = predict(mdl,test_X);
        
        % Compute confusion matrix:
        if cfg.classmodel.confmat
            cm{tp_} = confusionmat(test_Y,labels);
        end
        
        % Receiver operating characteristic (ROC curve)
        if cfg.classmodel.roc
            [x{tp_},y{tp_},~,auc(tp_)] = ...
                perfcurve(test_Y,scores(:,mdl.ClassNames),1);
        end
        
        % Compute correct rate:
        cr(tp_) = sum(test_Y == labels)/length(test_Y);
        
    end
else
    
    % Predict labels:
    [labels,scores] = predict(mdl,test_X);
    
    % Compute confusion matrix:
    if cfg.classmodel.confmat
        cm = confusionmat(test_Y,labels);
    end
    
    % Receiver operating characteristic (ROC curve)
    if cfg.classmodel.confmat
        [x,y,~,auc] = perfcurve(test_Y,scores(:,mdl.ClassNames),1);
    end
    
    % Compute correct rate:
    cr = sum(test_Y == labels)/length(test_Y);
    
    % mvpalab_svmvisualization(mdl,train_X,test_X,cfg,tp,train_Y,test_Y,auc);
end



end

