function precision = mvpalab_precision(confmat)
%% MVPALAB_PRECISION
%
%  This function computes the precision of each class from a confusion
%  matrix with the predicted classes in the rows and the true classes in
%  the columns, the transpose of the matrix returned by confusionmat (see
%  mvpalab_evalmetrics). A class that is never predicted has no precision
%  (0/0); it is set to 0, as scikit-learn does by default, so the mean of
%  the classes and the F1-score stay defined (see mvpalab_f1score).
%
%%  INPUT:
%
%  - {matrix} - confmat:
%    Confusion matrix [classes x classes], with the predicted classes in
%    the rows and the true classes in the columns.
%
%%  OUTPUT:
%
%  - {matrix} - precision:
%    Precision of each class [classes x 1].

    precision = diag(confmat) ./ sum(confmat,2);
    precision(isnan(precision)) = 0; % Class never predicted.
end

