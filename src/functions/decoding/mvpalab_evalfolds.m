function perf = mvpalab_evalfolds(cfg,train,test,part,tp)
%% MVPALAB_EVALFOLDS
%
%  This function evaluates one timepoint of one direction of the analysis:
%  in each fold the classifier is trained with some trials of the training
%  dataset and tested with some trials of the test dataset. In MVPA both
%  are dataset A. In MVCC they are different datasets. Each analysis decides
%  the trials of its folds in mvpalab_cvpartitions.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - train:
%    Data matrix (X) and labels (Y) of the training dataset.
%
%  - {struct} - test:
%    Data matrix (X) and labels (Y) of the test dataset.
%
%  - {struct} - part:
%    Trials of the training (part.train) and test (part.test) datasets of
%    each fold, generated once before the timepoints loop so that the same
%    partitions are used at all the timepoints (see mvpalab_cvpartitions).
%
%  - {int} - tp:
%    Timepoint.
%
%%  OUTPUT:
%
%  - {struct} - perf:
%    Performance of this timepoint (see mvpalab_evalmetrics).

X = train.X;
Y = train.Y;
Xt = test.X;
Yt = test.Y;

raw_weights = [];
haufe_weights = [];
params = [];

%% Cross validation loop:
if ~cfg.classmodel.tempgen
    predicted_labels = Yt([]);
    predicted_scores = [];
else
    for i = 1 : cfg.tm.ntp_
        predicted_labels{i} = Yt([]);
        predicted_scores{i} = [];
    end
end
true_labels = Yt([]);

for k = 1 : size(part.train,2)
    %% Update train and test datasets:
    train_X = X(part.train(:,k),:,cfg.tm.tpoints(tp));
    train_Y = Y(part.train(:,k));
    test_X = Xt(part.test(:,k),:,cfg.tm.tpoints(tp));
    test_Y = Yt(part.test(:,k));
    
    %% Test labels of all the folds:
    true_labels = [true_labels; test_Y];
    
    %% Data normalization if needed:
    [train_X,test_X,nparams] = mvpalab_datanorm(cfg,train_X,test_X,[]);
    
    %% Feature selection if needed:
    if ~strcmp(cfg.dimred.method,'none')
        [train_X,test_X,params] = ...
            mvpalab_dimred(train_X,train_Y,test_X,test_Y,cfg);
    end
    
    %% Train and test the model:
    [mdl,weights] = mvpalab_train(train_X,train_Y,cfg);
    
    % Correct feature weights and return them in the channel space:
    if cfg.classmodel.wvector
        haufe = mvpalab_wcorrect(train_X,weights);
        raw_weights(:,k) = mvpalab_backproject(weights,params,cfg);
        haufe_weights(:,k) = mvpalab_backproject(haufe,params,cfg);
    end
    
    %% Temporal generalization if needed:
    if cfg.classmodel.tempgen
        for tp_ = 1 : cfg.tm.ntp_
            
            % Update test set for the actual timepoint:
            test_X = Xt(part.test(:,k),:,cfg.tm.tpoints_(tp_));
            
            % Data normalization if needed:
            [~,test_X] = mvpalab_datanorm(cfg,[],test_X,nparams);
            
            % Project new test set in the PC space if needed
            if ~strcmp(cfg.dimred.method,'none')
                test_X = mvpalab_project(test_X,params,cfg);
            end
            
            % Predict labels and scores:
            [labels,scores] = predict(mdl,test_X);
            acc(k,tp_) = sum(test_Y == labels)/length(test_Y);
            
            % Update label and score vectors:
            predicted_labels{tp_} = [predicted_labels{tp_}; labels];
            predicted_scores{tp_} = [predicted_scores{tp_}; scores];
        end
    else
        % Test classifier:
        [labels,scores] = predict(mdl,test_X);
        acc(k) = sum(test_Y == labels)/length(test_Y);
        predicted_labels = [predicted_labels; labels];
        predicted_scores = [predicted_scores; scores];
    end
end

%% Calculate the performance of the model:
pred.truth = true_labels;
pred.labels = predicted_labels;
pred.scores = predicted_scores;
pred.class = mdl.ClassNames(1);
pred.acc = acc;
pred.raw = raw_weights;
pred.haufe = haufe_weights;

perf = mvpalab_evalmetrics(cfg,pred);

end
