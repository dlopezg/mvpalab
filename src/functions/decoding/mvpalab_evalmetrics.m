function perf = mvpalab_evalmetrics(pred,job)
%% MVPALAB_EVALMETRICS
%
%  This function computes the performance of the classifier at one
%  timepoint from its predictions in all the folds, at each test timepoint
%  (one, or all of them in temporal generalization). Only the metrics that
%  the analysis keeps (job.keep) are computed; the other fields are empty.
%
%%  INPUT:
%
%  - {struct} - pred:
%    - truth:   True labels of the test trials.
%    - labels:  Predicted labels, one cell per test timepoint.
%    - scores:  Predicted scores, one cell per test timepoint.
%    - class:   First class of the model, the positive class of the ROC.
%    - acc:     Accuracy of each fold and test timepoint [folds x ntp_].
%    - raw:     Feature weights of each fold.
%    - haufe:   Corrected feature weights of each fold.
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - perf:
%    - x, y, t: Coordinates and thresholds of the ROC curve, in cells
%               [1 x ntp_].
%    - auc:     Area under the curve [1 x ntp_].
%    - acc:     Correct rate [1 x ntp_].
%    - confmat: Confusion matrix [classes x classes x ntp_].
%    - precision, recall, f1score: Metrics of each class, in the third
%      dimension [1 x ntp_ x classes].
%    - wvector: Feature weights, raw and haufe_corrected [channels x 1].

for j = 1 : numel(pred.labels)
    tests(j) = testmetrics(job,pred.truth,pred.labels{j},pred.scores{j},...
        pred.class);
end

for f = {'x','y','t'}
    perf.(f{1}) = {tests.(f{1})};
end
for f = {'auc','precision','recall','f1score'}
    perf.(f{1}) = [tests.(f{1})];
end
perf.confmat = cat(3,tests.confmat);
perf.acc = mean(pred.acc,1);

% Feature weights:
perf.wvector = [];
if job.wvector
    perf.wvector.raw = mean(pred.raw,2);
    perf.wvector.haufe_corrected = mean(pred.haufe,2);
end

end

function perf = testmetrics(job,truth,labels,scores,class)
%% Metrics of the predictions at one test timepoint.

keep = @(metrics) any(ismember(metrics,job.keep));

perf.x = {}; perf.y = {}; perf.t = {}; perf.auc = NaN;
perf.confmat = []; perf.precision = []; perf.recall = []; perf.f1score = [];

% Compute confusion matrix if needed:
if keep({'confmat','precision','recall','f1score'})
    perf.confmat = confusionmat(truth,labels);
end

% Metrics of each class if needed:
if keep({'precision'})
    perf.precision = shiftdim(mvpalab_precision(perf.confmat'),-2);
end
if keep({'recall'})
    perf.recall = shiftdim(mvpalab_recall(perf.confmat'),-2);
end
if keep({'f1score'})
    perf.f1score = shiftdim(mvpalab_f1score(perf.confmat'),-2);
end

% Receiver operating characteristic (ROC curve) if needed:
if keep({'auc','x'})
    [perf.x,perf.y,perf.t,perf.auc] = perfcurve(truth,scores(:,1),class);
end

end
