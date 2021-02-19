function [x,y,t,auc,cr,cm,pr,re,f1,w] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar)
%This function returns the accuracy of the classifier in a time-resolved way.

% x = x-coordinates of the ROC curve.
% y = y-coordinates of the ROC curve.
% t =
% auc = Area Under the Curve value.
% cr = Correct rate.
% cm = Confusion matrix.

x = {}; y = {}; t = {}; auc = NaN;   
cm = {}; pr = {}; re = {}; f1 = {};
cr = NaN;
w = []; 

%% Cross validation loop:
if ~cfg.classmodel.tempgen
    predicted_labels = true(strpar.NumObservations,1);
    predicted_scores = ones(strpar.NumObservations,2);
else
    for i = 1 : cfg.tm.ntp
        predicted_labels{i} = true(strpar.NumObservations,1);
        predicted_scores{i} = ones(strpar.NumObservations,2);
    end
end

for k = 1 : strpar.NumTestSets
    %% Train and test data:
    train_X = X(strpar.training(k),:,cfg.tm.tpoints(tp));
    train_Y = Y(strpar.training(k));
    test_X = X(strpar.test(k),:,cfg.tm.tpoints(tp));
    test_Y = Y(strpar.test(k));
    
    %% Data normalization if needed:
    [train_X,test_X,nparams] = mvpalab_datanorm(cfg,train_X,test_X,[]);
    
    %% Permute labels if needed:
    if cfg.classmodel.permlab
        train_Y = train_Y(randperm(length(train_Y)));
    end
    
    %% Feature selection if needed:
    if cfg.dimred.flag
        [train_X,test_X,params] = ...
            mvpalab_dimred(train_X,train_Y,test_X,test_Y,cfg);
    end
    
    %% Train and test the model:
    [mdl,w] = mvpalab_train(train_X,train_Y,cfg);
    
    % Temporal generalization if needed:
    if cfg.classmodel.tempgen
        for tp_ = 1 : cfg.tm.ntp
            
            % Update test set for the actual timepoint:
            test_X = X(strpar.test(k),:,cfg.tm.tpoints(tp_));
            
            % Data normalization if needed:
            [~,test_X] = mvpalab_datanorm(cfg,[],test_X,nparams);
            
            % Project new test set in the PC space if needed
            if cfg.dimred.flag
                test_X = mvpalab_project(test_X,params,cfg);
            end
            
            % Predict labels and scores:
            [labels,scores] = predict(mdl,test_X);
            acc(k,tp_) = sum(test_Y == labels)/length(test_Y);
            
            % Update label and score vectors:
            predicted_labels{tp_}(strpar.test(k)) = labels;
            predicted_scores{tp_}(strpar.test(k),:) = scores;
        end
    else
        % Test classifier:
        [labels,scores] = predict(mdl,test_X);
        acc(k) = sum(test_Y == labels)/length(test_Y);
        predicted_labels(strpar.test(k)) = labels;
        predicted_scores(strpar.test(k),:) = scores;
    end
end

%% Calculate the performance of the model:
if cfg.classmodel.tempgen
    for tp_ = 1 : cfg.tm.ntp
        % Compute confusion matrix if needed:
        if cfg.classmodel.confmat || cfg.classmodel.precision ...
            || cfg.classmodel.recall || cfg.classmodel.f1score
            cm{tp_} = confusionmat(Y,predicted_labels{tp_});
        end
        % Compute precision if needed:
        if cfg.classmodel.precision
            pr{tp_} =  mvpalab_precision(cm{tp_}');
        end
        % Compute recall if needed:
        if cfg.classmodel.precision
            re{tp_} =  mvpalab_recall(cm{tp_}');
        end
        % Compute F1-score if needed:
        if cfg.classmodel.precision
            f1{tp_} =  mvpalab_f1score(cm{tp_}');
        end
        % Receiver operating characteristic (ROC curve) if needed:
        if cfg.classmodel.auc || cfg.classmodel.roc
            [x{tp_},y{tp_},t{tp_},auc(tp_)] = ...
                perfcurve(Y,predicted_scores{tp_}(:,mdl.ClassNames),1);
        end
    end
    % Mean accuracy:
    cr = mean(acc);
else
    % Mean accuracy:
    cr = mean(acc);
    % Compute confusion matrix if needed:
    if cfg.classmodel.confmat || cfg.classmodel.precision ...
            || cfg.classmodel.recall || cfg.classmodel.f1score
        cm = confusionmat(Y,predicted_labels);
    end
    % Compute precision if needed:
    if cfg.classmodel.precision
        pr =  mvpalab_precision(cm');
    end
    % Compute recall if needed:
    if cfg.classmodel.precision
        re =  mvpalab_recall(cm');
    end
    % Compute F1-score if needed:
    if cfg.classmodel.precision
        f1 =  mvpalab_f1score(cm');
    end
    % Receiver operating characteristic (ROC curve):
    if cfg.classmodel.auc || cfg.classmodel.roc
        [x,y,t,auc] = perfcurve(Y,predicted_scores(:,mdl.ClassNames),1);
    end
end

end