function confusionmatrix = mvpalab_perfmetrics(confmat)
    confusionmatrix.confmat = confmat;
    confusionmatrix.precision = mvpalab_precision(confmat');
    confusionmatrix.recall = mvpalab_recall(confmat');
    confusionmatrix.f1score = mvpalab_f1score(confmat');
end

