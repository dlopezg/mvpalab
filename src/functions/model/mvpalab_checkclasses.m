function mvpalab_checkclasses(cfg)
%% MVPALAB_CHECKCLASSES
%
%  This function checks the classes of an analysis, so it stops before it
%  starts:
%
%  - Each class needs its own name in cfg.study.conditionIdentifier, because
%    two classes with the same name share a field in mvpalab_import and one
%    of them is lost without any error.
%  - In MVCC, dataset B needs the same classes as dataset A.
%  - With more than two classes, a decoding analysis cannot use the metrics
%    that are only defined for two classes:
%    - cfg.classmodel.wvector: there is one set of feature weights per pair
%      of classes.
%    - cfg.classmodel.auc and cfg.classmodel.roc: the ROC curve of
%      mvpalab_evalmetrics compares the first class with the others, so its
%      result would depend on the order of the classes. In a sliding filter
%      analysis cfg.sf.metric = 'auc' enables cfg.classmodel.auc.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.analysis, cfg.study and cfg.classmodel).

nclass = size(cfg.study.dataFiles,2);
mvcc = strcmp(cfg.analysis,'MVCC');

for ctxt = 1 : 1 + mvcc
    ids = cfg.study.conditionIdentifier(ctxt,1:nclass);
    ids = cellfun(@(id) id(~isspace(id)),ids,'UniformOutput',false);
    if numel(unique(ids)) < nclass
        error('The names in cfg.study.conditionIdentifier must be different.');
    end
end

% An fv built by hand can have dataset B out of cfg.study.dataFiles:
missing = cellfun(@isempty,cfg.study.dataFiles(2,:));
if mvcc && any(missing) && ~all(missing)
    error('In MVCC, dataset B needs the same classes as dataset A.');
end

if nclass < 3 || ~any(strcmp(cfg.analysis,{'MVPA','MVCC'})), return; end

metrics = {'wvector','auc','roc'};
enabled = cellfun(@(metric) logical(cfg.classmodel.(metric)),metrics);

if any(enabled)
    error('cfg.classmodel.%s needs two classes.',metrics{find(enabled,1)});
end

end
