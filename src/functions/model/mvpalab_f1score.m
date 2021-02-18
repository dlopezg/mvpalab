function f1score = mvpalab_f1score(confmat)
    precision = mvpalab_precision(confmat);
    recall = mvpalab_recall(confmat);
    f1score = 2 * ( precision .* recall) ./ (precision + recall);
end

