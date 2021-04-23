function [x,y,t,auc,cr,cm,pr,re,f1,w] = mvpalab_mvcceval(X,train_Y,Xt,test_Y,tp,cfg)
%MVCC_SVM_CLASSIFIER Summary of this function goes here
%   Detailed explanation goes here

x = {}; y = {}; t = {}; auc = NaN;
cm = {}; pr = {}; re = {}; f1 = {};
cr = NaN;
raw_weights = [];
w = [];

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
if ~strcmp(cfg.dimred.method,'none')
    [train_X,test_X,params] = ...
        mvpalab_dimred(train_X,train_Y,test_X,test_Y,cfg);
end

%% Train and test the model:
[mdl,raw_weights] = mvpalab_train(train_X,train_Y,cfg);

% Correct feature weights:
if cfg.classmodel.wvector
    haufe_weights = mvpalab_wcorrect(train_X,raw_weights);
end


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
        if ~strcmp(cfg.dimred.method,'none')
            test_X = mvpalab_project(test_X,params,cfg);
        end
        
        % Predict labels and scores:
        [labels,scores] = predict(mdl,test_X);
        
        % Compute mean accuracy:
        cr(tp_) = sum(test_Y == labels)/length(test_Y);
        
        % Compute confusion matrix if needed:
        if cfg.classmodel.confmat || cfg.classmodel.precision ...
                || cfg.classmodel.recall || cfg.classmodel.f1score
            cm{tp_} = confusionmat(test_Y,labels);
        end
        % Receiver operating characteristic (ROC curve)
        if cfg.classmodel.auc || cfg.classmodel.roc
            [x{tp_},y{tp_},t{tp_},auc(tp_)] = ...
                perfcurve(test_Y,scores(:,mdl.ClassNames),1);
        end
        % Compute precision if needed:
        if cfg.classmodel.precision
            pr{tp_} =  mvpalab_precision(cm{tp_}');
        end
        % Compute recall if needed:
        if cfg.classmodel.recall
            re{tp_} =  mvpalab_recall(cm{tp_}');
        end
        % Compute F1-score if needed:
        if cfg.classmodel.f1score
            f1{tp_} =  mvpalab_f1score(cm{tp_}');
        end
    end
else
    
    % Predict labels:
    [labels,scores] = predict(mdl,test_X);
    
    % Compute mean accuracy:
    cr = sum(test_Y == labels)/length(test_Y);
    % Compute confusion matrix if needed:
    if cfg.classmodel.confmat || cfg.classmodel.precision ...
            || cfg.classmodel.recall || cfg.classmodel.f1score
        cm = confusionmat(test_Y,labels);
    end
    % Compute precision if needed:
    if cfg.classmodel.precision
        pr =  mvpalab_precision(cm');
    end
    % Compute recall if needed:
    if cfg.classmodel.recall
        re =  mvpalab_recall(cm');
    end
    % Compute F1-score if needed:
    if cfg.classmodel.f1score
        f1 =  mvpalab_f1score(cm');
    end
    % Receiver operating characteristic (ROC curve):
    if cfg.classmodel.auc || cfg.classmodel.roc
        [x,y,t,auc] = perfcurve(test_Y,scores(:,mdl.ClassNames),1);
    end
    % mvpalab_svmvisualization(mdl,train_X,test_X,cfg,tp,train_Y,test_Y,auc);
end

% Feature weights:
if cfg.classmodel.wvector
    w.raw = raw_weights;
    w.haufe_corrected = mean(haufe_weights,2);
end
end

