function perf = mvpalab_mvpaeval(cfg,data,strpar,tp)
%% MVPALAB_MVPAEVAL
%
%  This function evaluates one timepoint of the decoding analysis with
%  cross-validation.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - data:
%    Data matrix (X) and labels (Y) of the dataset.
%
%  - {cvpartition} - strpar:
%    Cross-validation partition, generated once before the timepoints loop
%    so that the same partition is used at all the timepoints.
%
%  - {int} - tp:
%    Timepoint.
%
%%  OUTPUT:
%
%  - {struct} - perf:
%    Performance of this timepoint (see mvpalab_evalmetrics).

X = data.X;
Y = data.Y;

raw_weights = [];
haufe_weights = [];
params = [];

%% Cross validation loop:
if ~cfg.classmodel.tempgen
    predicted_labels = Y; predicted_labels(:) = missing;
    predicted_scores = ones(strpar.NumObservations,2);
else
    for i = 1 : cfg.tm.ntp_
        predicted_labels{i} = Y; predicted_labels{i}(:) = missing;
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
            test_X = X(strpar.test(k),:,cfg.tm.tpoints_(tp_));
            
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
pred.truth = Y;
pred.labels = predicted_labels;
pred.scores = predicted_scores;
pred.class = mdl.ClassNames(1);
pred.acc = acc;
pred.raw = raw_weights;
pred.haufe = haufe_weights;

perf = mvpalab_evalmetrics(cfg,pred);

end
