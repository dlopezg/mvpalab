function cfg = mvpalab_sfmetrics(cfg)
%% MVPALAB_SFMETRICS
%
%  This function selects the performance metrics of a sliding filter
%  analysis. It disables cfg.classmodel.roc, auc, confmat, precision,
%  recall, f1score and wvector, and it enables cfg.classmodel.auc again if
%  cfg.sf.metric is 'auc'. The accuracy is computed by default.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.sf.metric).
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure.

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

