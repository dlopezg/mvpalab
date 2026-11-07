function perf = mvpalab_evalfolds(cfg,train,test,part,tp,job)
%% MVPALAB_EVALFOLDS
%
%  This function evaluates one timepoint of one direction of the analysis:
%  in each fold the classifier is trained with some trials of the training
%  dataset and tested with some trials of the test dataset. In MVPA both
%  are dataset A. In MVCC they are different datasets. Each analysis decides
%  the trials of its folds in mvpalab_cvpartitions.
%
%  The model trained at timepoint tp is tested at the same timepoint or, in
%  temporal generalization, at every test timepoint (cfg.tm.tpoints_). Each
%  test set gets the transformation fitted on the training set of its fold
%  (see mvpalab_fitfold).
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
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - perf:
%    Performance of this timepoint (see mvpalab_evalmetrics).

%% Test timepoints of the model:
tps = cfg.tm.tpoints(tp);
if cfg.classmodel.tempgen, tps = cfg.tm.tpoints_; end

nfolds = size(part.train,2);
truth = cell(nfolds,1);
labels = cell(nfolds,numel(tps));
scores = labels;
acc = zeros(nfolds,numel(tps));
raw = [];
haufe = [];

%% Cross validation loop:
for k = 1 : nfolds
    %% Train the model with the transformation of the fold:
    train_X = train.X(part.train(:,k),:,cfg.tm.tpoints(tp));
    [train_X,fold] = mvpalab_fitfold(cfg,train_X);
    [mdl,weights] = mvpalab_train(train_X,train.Y(part.train(:,k)),cfg);

    % Feature weights in the channel space:
    if job.wvector
        raw(:,k) = mvpalab_backproject(weights,fold);
        haufe(:,k) = mvpalab_backproject(mvpalab_wcorrect(train_X,weights),fold);
    end

    %% Test the model at each test timepoint:
    truth{k} = test.Y(part.test(:,k));
    for j = 1 : numel(tps)
        test_X = mvpalab_applyfold(test.X(part.test(:,k),:,tps(j)),fold);
        [labels{k,j},scores{k,j}] = predict(mdl,test_X);
        acc(k,j) = sum(truth{k} == labels{k,j})/length(truth{k});
    end
end

%% Calculate the performance of the model:
pred.truth = vertcat(truth{:});
for j = 1 : numel(tps)
    pred.labels{j} = vertcat(labels{:,j});
    pred.scores{j} = vertcat(scores{:,j});
end
pred.class = mdl.ClassNames(1);
pred.acc = acc;
pred.raw = raw;
pred.haufe = haufe;

perf = mvpalab_evalmetrics(pred,job);

end
