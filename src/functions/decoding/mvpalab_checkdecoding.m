function mvpalab_checkdecoding(cfg,mode)
%% MVPALAB_CHECKDECODING
%
%  This function checks the settings of a decoding analysis (MVPA or MVCC)
%  before it starts, so a wrong setting stops with a clear error instead of
%  failing later or giving a wrong result:
%
%  - The classes of the analysis (see mvpalab_checkclasses).
%  - With more than two classes, the metrics that are only defined for two
%    classes are not available:
%    - cfg.classmodel.wvector: there is one set of feature weights per pair
%      of classes.
%    - cfg.classmodel.auc and cfg.classmodel.roc: the ROC curve of
%      mvpalab_evalmetrics compares the first class with the others, so its
%      result would depend on the order of the classes. In a sliding filter
%      analysis cfg.sf.metric = 'auc' enables cfg.classmodel.auc.
%  - The methods of the analysis (see mvpalab_checkmethods).
%  - Observed maps: the settings of the sign flip test (see
%    mvpalab_checksignflip) and the feature weights (see
%    mvpalab_checkwvector). The sign flip test is not available with
%    leave-one-out in MVPA: the left-out trial leaves its class with one
%    trial less in the training set, so the accuracy without effect is
%    below 0.5. This also applies to a sliding filter analysis.
%  - Permuted maps: the sign flip test has no permuted maps (see
%    mvpalab_nullmaps), so it gives an error.
%
%  mvpalab_decoding and mvpalab_sfilter call it.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {string} - mode:
%    'observed' or 'permuted'.

mvpalab_checkclasses(cfg);

metrics = {'wvector','auc','roc'};
enabled = cellfun(@(metric) logical(cfg.classmodel.(metric)),metrics);
if size(cfg.study.dataFiles,2) > 2 && any(enabled)
    error('cfg.classmodel.%s needs two classes.',metrics{find(enabled,1)});
end

mvpalab_checkmethods(cfg);

if strcmp(mode,'permuted')
    if cfg.stats.signflip
        error('The sign flip test has no permuted maps. Use mvpalab_nullmaps.');
    end
else
    mvpalab_checksignflip(cfg);
    if cfg.stats.signflip && ~mvpalab_ismvcc(cfg) && strcmp(cfg.cv.method,'loo')
        error('The sign flip test is not available with leave-one-out in MVPA.');
    end
    mvpalab_checkwvector(cfg);
end

end
