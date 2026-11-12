function mvpalab_validatedecoding(cfg,mode)
%% MVPALAB_VALIDATEDECODING
%
%  This function checks the settings of a decoding analysis (MVPA or MVCC)
%  before it starts, so a wrong setting stops with a clear error instead of
%  failing later or giving a wrong result:
%
%  - The classes of the analysis (see mvpalab_validateclasses).
%  - With more than two classes, the metrics that are only defined for two
%    classes are not available:
%    - cfg.classmodel.wvector: there is one set of feature weights per pair
%      of classes.
%    - cfg.classmodel.auc and cfg.classmodel.roc: the ROC curve of
%      mvpalab_evalmetrics compares the first class with the others, so its
%      result would depend on the order of the classes. In a sliding filter
%      analysis cfg.sf.metric = 'auc' enables cfg.classmodel.auc.
%  - The methods of the analysis (see mvpalab_validateclassifier) and the
%    supertrials (see mvpalab_validatesupertrials).
%  - The settings of the permutation test (see mvpalab_validatestats).
%  - Observed maps: the settings of the sign flip test (see
%    mvpalab_validatesignflip) and the feature weights (see
%    mvpalab_validateweights). The sign flip test is not available with
%    leave-one-out in MVPA: the left-out trial leaves its class with one
%    trial less in the training set, so the accuracy without effect is
%    below 0.5. This also applies to a sliding filter analysis.
%  - Permuted maps: the sign flip test has no permuted maps (see
%    mvpalab_decodingnullmaps), so it gives an error.
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

mvpalab_validateclasses(cfg);

metrics = {'wvector','auc','roc'};
enabled = cellfun(@(metric) logical(cfg.classmodel.(metric)),metrics);
if size(cfg.study.dataFiles,2) > 2 && any(enabled)
    error('mvpalab:validatedecoding',...
        'cfg.classmodel.%s needs two classes.',metrics{find(enabled,1)});
end

mvpalab_validateclassifier(cfg);
mvpalab_validatesupertrials(cfg);
mvpalab_validatestats(cfg);

if strcmp(mode,'permuted')
    if cfg.stats.signflip
        error('mvpalab:validatedecoding',...
            'The sign flip test has no permuted maps. Use mvpalab_decodingnullmaps.');
    end
else
    mvpalab_validatesignflip(cfg);
    if cfg.stats.signflip && ~mvpalab_ismvcc(cfg) && strcmp(cfg.cv.method,'loo')
        error('mvpalab:validatedecoding',...
            'The sign flip test is not available with leave-one-out in MVPA.');
    end
    mvpalab_validateweights(cfg);
end

end
