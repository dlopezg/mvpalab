function perf = mvpalab_evalmetrics(cfg,pred)
%% MVPALAB_EVALMETRICS
%
%  This function computes the performance of the classifier at one
%  timepoint from its predictions in all the folds. In a temporal
%  generalization analysis the metrics are computed for each test
%  timepoint.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - pred:
%    - truth:   True labels of the test trials.
%    - labels:  Predicted labels (one cell per test timepoint in temporal
%               generalization).
%    - scores:  Predicted scores (one cell per test timepoint in temporal
%               generalization).
%    - class:   First class of the model, the positive class of the ROC.
%    - acc:     Accuracy of each fold.
%    - raw:     Feature weights of each fold.
%    - haufe:   Corrected feature weights of each fold.
%
%%  OUTPUT:
%
%  - {struct} - perf:
%    - x, y, t: Coordinates and thresholds of the ROC curve.
%    - auc:     Area under the curve.
%    - acc:     Correct rate.
%    - confmat: Confusion matrix.
%    - precision, recall, f1score: Metrics of each class.
%    - wvector: Feature weights.

if cfg.classmodel.tempgen
    for tp_ = 1 : cfg.tm.ntp_
        tests(tp_) = testmetrics(cfg,pred.truth,pred.labels{tp_},...
            pred.scores{tp_},pred.class);
    end
    fields = fieldnames(tests);
    for f = 1 : numel(fields)
        perf.(fields{f}) = {tests.(fields{f})};
    end
    perf.auc = [tests.auc];
    perf.acc = mean(pred.acc,1);
else
    perf = testmetrics(cfg,pred.truth,pred.labels,pred.scores,pred.class);
    perf.acc = mean(pred.acc);
end

% Feature weights:
perf.wvector = [];
if cfg.classmodel.wvector
    perf.wvector.raw = mean(pred.raw,2);
    perf.wvector.haufe_corrected = mean(pred.haufe,2);
end

end

function perf = testmetrics(cfg,truth,labels,scores,class)
%% Metrics of the predictions at one test timepoint.

perf.x = {}; perf.y = {}; perf.t = {}; perf.auc = NaN;
perf.confmat = {}; perf.precision = {}; perf.recall = {}; perf.f1score = {};

% Compute confusion matrix if needed:
if cfg.classmodel.confmat || cfg.classmodel.precision ...
        || cfg.classmodel.recall || cfg.classmodel.f1score
    perf.confmat = confusionmat(truth,labels);
end

% Compute precision if needed:
if cfg.classmodel.precision
    perf.precision = mvpalab_precision(perf.confmat');
end

% Compute recall if needed:
if cfg.classmodel.recall
    perf.recall = mvpalab_recall(perf.confmat');
end

% Compute F1-score if needed:
if cfg.classmodel.f1score
    perf.f1score = mvpalab_f1score(perf.confmat');
end

% Receiver operating characteristic (ROC curve) if needed:
if cfg.classmodel.auc || cfg.classmodel.roc
    [perf.x,perf.y,perf.t,perf.auc] = perfcurve(truth,scores(:,1),class);
end

end
