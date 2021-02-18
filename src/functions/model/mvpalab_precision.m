function precision = mvpalab_precision(confmat)
    precision = diag(confmat) ./ sum(confmat,2);
end

