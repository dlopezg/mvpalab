function [x,y,t,auc,cr,cm,pr,re,f1,w] = mvpalab_mvcceval(X,Y,Xt,Yt,tp,cfg)

x = {}; y = {}; t = {}; auc = NaN;
cm = {}; pr = {}; re = {}; f1 = {};
cr = NaN;
raw_weights = [];
w = [];

%% Cross validation loop:

% Stratified partitions for train and test datasets:
strpar  = cvpartition(Y,'KFold',cfg.cv.nfolds);  % Train
strpart = cvpartition(Yt,'KFold',cfg.cv.nfolds); % Test

if ~cfg.classmodel.tempgen
    predicted_labels = true(strpart.NumObservations,1);
    predicted_scores = ones(strpart.NumObservations,2);
else
    for i = 1 : cfg.tm.ntp
        predicted_labels{i} = true(strpart.NumObservations,1);
        predicted_scores{i} = ones(strpart.NumObservations,2);
    end
end

for k = 1 : strpar.NumTestSets
    %% Update train and test datasets:
    
    % Select data partition for testing
    selected_partition = strpart.training(k);
    
    train_X = X(strpar.training(k),:,cfg.tm.tpoints(tp));
    train_Y = Y(strpar.training(k));
    test_X = Xt(selected_partition,:,cfg.tm.tpoints(tp));
    test_Y = Yt(selected_partition);
    
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
    [mdl,raw_weights(:,k)] = mvpalab_train(train_X,train_Y,cfg);
    
    %% Correct feature weights:
    if cfg.classmodel.wvector
        haufe_weights(:,k) = mvpalab_wcorrect(train_X,raw_weights(:,k));
    end
    
    %% Temporal generalization if needed:
    if cfg.classmodel.tempgen
        for tp_ = 1 : cfg.tm.ntp
            
            % Update test set for the actual timepoint:
            test_X = Xt(selected_partition,:,cfg.tm.tpoints(tp_));
            
            % Data normalization if needed:
            [~,test_X,nparams] = mvpalab_datanorm(cfg,[],test_X,nparams);
            
            % Project new test set in the PC space if needed:
            if ~strcmp(cfg.dimred.method,'none')
                test_X = mvpalab_project(test_X,params,cfg);
            end
            
            % Predict labels and scores:
            [labels,scores] = predict(mdl,test_X);
            acc(k,tp_) = sum(test_Y == labels)/length(test_Y);
            
            % Update label and score vectors:
            predicted_labels{tp_}(selected_partition) = labels;
            predicted_scores{tp_}(selected_partition,:) = scores;
        
        end
    else
        
        % Test classifier:
        [labels,scores] = predict(mdl,test_X);
        acc(k) = sum(test_Y == labels)/length(test_Y);
        predicted_labels(selected_partition) = labels;
        predicted_scores(selected_partition,:) = scores;
 
    end
end

%% Calculate the performance of the model:

if cfg.classmodel.tempgen
    for tp_ = 1 : cfg.tm.ntp
        % Compute confusion matrix if needed:
        if cfg.classmodel.confmat || cfg.classmodel.precision ...
            || cfg.classmodel.recall || cfg.classmodel.f1score
            cm{tp_} = confusionmat(Yt,predicted_labels{tp_});
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
        % Receiver operating characteristic (ROC curve) if needed:
        if cfg.classmodel.auc || cfg.classmodel.roc
            [x{tp_},y{tp_},t{tp_},auc(tp_)] = ...
                perfcurve(Yt,predicted_scores{tp_}(:,mdl.ClassNames),1);
        end
    end
    
    % Feature weights:
    if cfg.classmodel.wvector
        w.raw = mean(raw_weights,2);
        w.haufe_corrected = mean(haufe_weights,2);
    end
    
    % Mean accuracy:
    cr = mean(acc);
else
    % Mean accuracy:
    cr = mean(acc);
    % Compute confusion matrix if needed:
    if cfg.classmodel.confmat || cfg.classmodel.precision ...
            || cfg.classmodel.recall || cfg.classmodel.f1score
        cm = confusionmat(Yt,predicted_labels);
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
        [x,y,t,auc] = perfcurve(Yt,predicted_scores(:,mdl.ClassNames),1);
    end
    % Feature weights:
    if cfg.classmodel.wvector
        w.raw = mean(raw_weights,2);
        w.haufe_corrected = mean(haufe_weights,2);
    end
end

end

