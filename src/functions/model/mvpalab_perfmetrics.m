function performance = mvpalab_perfmetrics(cfg,Y,predicted_labels,predicted_scores,mdl)
    performance.confmat = confmat;
    performance.precision = mvpalab_precision(confmat');
    performance.recall = mvpalab_recall(confmat');
    performance.f1score = mvpalab_f1score(confmat');
    
    % Receiver operating characteristic (ROC curve):
    if cfg.classmodel.roc
        [x,y,t,auc] = perfcurve(Y,predicted_scores(:,mdl.ClassNames),1);
    end
    
    if cfg.classmodel.confmat
        performance.confusionmat = confusionmat(Y,predicted_labels);
    end
end

