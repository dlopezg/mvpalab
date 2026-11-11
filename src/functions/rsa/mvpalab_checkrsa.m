function mvpalab_checkrsa(cfg)
%% MVPALAB_CHECKRSA
%
%  This function checks the settings of a time-resolved RSA before it
%  starts:
%
%  - cfg.rsa.modality is 'corr', 'regress' or 'multiple_regress'.
%  - There is at least one theoretical model (cfg.rsa.tmodels).
%  - Each theoretical model has its own id, and the id
%    is a valid field name other than 'rdms' and 'theo', the fields of the
%    result that hold the RDMs: a model with one of these ids would lose
%    its result without any error.
%  - cfg.normdata is 0, 1, 2, 3 or 4. The values 3 and 4 are applied
%    within the folds of the classifiers (see mvpalab_preparetrain) and
%    have no effect in RSA, so a warning is shown. The values 1 and 2 are
%    applied to each trial or supertrial (see mvpalab_normtrials).
%  - The settings of the supertrials (see mvpalab_checktrialaver).
%  - The settings of the permutation test (see mvpalab_checkstats) and of
%    the sign flip test (see mvpalab_checksignflip).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.rsa and cfg.normdata).

mode = cfg.rsa.modality;
if ~any(strcmp(mode,{'corr','regress','multiple_regress'}))
    error(['RSA modality not recognized: ''%s''. Use ''corr'', ' ...
        '''regress'' or ''multiple_regress''.'],mode);
end

if isempty(cfg.rsa.tmodels)
    error('cfg.rsa.tmodels needs at least one theoretical model.');
end

ids = cellfun(@(model) model.id,cfg.rsa.tmodels,'UniformOutput',false);
if numel(unique(ids)) < numel(ids)
    error('Each model in cfg.rsa.tmodels needs its own id.');
end
invalid = find(~cellfun(@isvarname,ids) | ismember(ids,{'rdms','theo'}),1);
if ~isempty(invalid)
    error(['The id ''%s'' of cfg.rsa.tmodels cannot be used: it must be a ' ...
        'valid field name other than ''rdms'' and ''theo''.'],ids{invalid});
end

mvpalab_checktrialaver(cfg);
mvpalab_checkstats(cfg);
mvpalab_checksignflip(cfg);

if ~isscalar(cfg.normdata) || ~ismember(cfg.normdata,0:4)
    error('cfg.normdata must be 0, 1, 2, 3 or 4.');
end
if cfg.normdata >= 3
    warning(['cfg.normdata = %d is only applied by the classifiers ' ...
        '(MVPA and MVCC) and has no effect in RSA. Use cfg.normdata = 1 ' ...
        'or 2 (applied to each trial or supertrial) or 0.'],cfg.normdata);
end

end
