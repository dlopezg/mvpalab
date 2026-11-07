function recall = mvpalab_recall(confmat)
%% MVPALAB_RECALL
%
%  This function computes the recall of each class from a confusion matrix
%  with the predicted classes in the rows and the true classes in the
%  columns, the transpose of the matrix returned by confusionmat (see
%  mvpalab_evalmetrics). The recall of a class without test trials is NaN.
%
%%  INPUT:
%
%  - {matrix} - confmat:
%    Confusion matrix [classes x classes], with the predicted classes in
%    the rows and the true classes in the columns.
%
%%  OUTPUT:
%
%  - {matrix} - recall:
%    Recall of each class [classes x 1].

    recall = diag(confmat) ./ sum(confmat,1)';
end


