function f1score = mvpalab_f1score(confmat)
%% MVPALAB_F1SCORE
%
%  This function computes the F1-score of each class, the harmonic mean of
%  its precision and recall (see mvpalab_precision and mvpalab_recall),
%  from a confusion matrix with the predicted classes in the rows and the
%  true classes in the columns, the transpose of the matrix returned by
%  confusionmat (see mvpalab_evalmetrics). The F1-score is 0 when it is
%  not defined, for example for a class without correct predictions.
%
%%  INPUT:
%
%  - {matrix} - confmat:
%    Confusion matrix [classes x classes], with the predicted classes in
%    the rows and the true classes in the columns.
%
%%  OUTPUT:
%
%  - {matrix} - f1score:
%    F1-score of each class [classes x 1].

    precision = mvpalab_precision(confmat);
    recall = mvpalab_recall(confmat);
    f1score = 2 * ( precision .* recall) ./ (precision + recall);
    f1score(isnan(f1score)) = 0; % No correct predictions of the class.
end

