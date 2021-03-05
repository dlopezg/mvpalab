function cfg = mvpalab_sfmetrics(cfg)
% Disable all performance metrics:
cfg.classmodel.roc       = false;
cfg.classmodel.auc       = false;
cfg.classmodel.confmat   = false;
cfg.classmodel.precision = false;
cfg.classmodel.recall    = false;
cfg.classmodel.f1score   = false;
cfg.classmodel.wvector   = false;

% Enable AUC if needed (ACC enabled by default)
if strcmp(cfg.sf.metric, 'auc')
    cfg.classmodel.auc = true;
end

end

