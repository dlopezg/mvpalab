function recall = mvpalab_recall(confmat)
    recall = diag(confmat) ./ sum(confmat,1)';
end


