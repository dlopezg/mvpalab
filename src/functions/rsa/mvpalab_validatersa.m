function mvpalab_validatersa(cfg,nconds)
%% MVPALAB_VALIDATERSA
%
%  This function checks the settings of an RSA before it starts, the
%  time-resolved M/EEG analysis (mvpalab_rsa_time) and the fMRI regions of
%  interest (mvpalab_rsa_roi):
%
%  - cfg.rsa.modality is 'corr', 'regress' or 'multiple_regress'.
%  - There is at least one theoretical model (cfg.rsa.tmodels).
%  - Each theoretical model has its own id, and the id
%    is a valid field name other than 'rdms' and 'theo', the fields of the
%    result that hold the RDMs: a model with one of these ids would lose
%    its result without any error.
%  - Each model is a [nconds x nconds] matrix, one row per condition, and
%    its values are not all equal: a constant model gives NaN at every
%    timepoint. In condition-wise RDMs the values are those of the pairs
%    of conditions; in trial-wise RDMs the diagonal also enters, as the
%    pairs of trials of the same condition.
%  - Condition-wise RDMs have enough pairs of conditions for the second
%    order statistic: 3 for 'corr' and 'regress' and the number of models
%    plus 2 for 'multiple_regress' (the intercept and one degree of
%    freedom for the error). Otherwise the result is NaN or meaningless.
%  - The RDMs: cfg.rsa.nfolds and cfg.rsa.nreps are whole numbers of at
%    least 1. The crossnobis distance is cross-validated, so it needs
%    cfg.rsa.nfolds > 1. Cross-validated RDMs compare the pattern of each
%    condition in the training set with that of each condition in the test
%    set, so they need condition-wise RDMs (cfg.rsa.trialwise = false): in
%    trial-wise RDMs the training and test trials are different trials.
%    The checks that depend on the data are in mvpalab_validaterdm.
%  - cfg.normdata is 0, 1, 2, 3 or 4. The values 3 and 4 are applied
%    within the folds of the classifiers (see mvpalab_preparetrain) and
%    have no effect in RSA, so a warning is shown. The values 1 and 2 are
%    applied to each trial or supertrial (see mvpalab_normtrials).
%  - cfg.dimred is not applied in RSA, so a warning is shown if
%    cfg.dimred.method is 'pca'. The RDMs use all the channels or voxels:
%    the principal components are ordered by their total variance, not by
%    the differences between conditions, and they would change the
%    Pearson distance and the scale of the Euclidean family.
%  - The settings of the supertrials (see mvpalab_validatesupertrials).
%  - The settings of the permutation test (see mvpalab_validatestats) and
%    of the sign flip test (see mvpalab_validatesignflip).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.rsa, cfg.normdata and cfg.dimred).
%
%  - {int} - nconds:
%    Number of conditions: the classes of the study in M/EEG
%    (size(cfg.study.dataFiles,2)) or cfg.rsa.conditions in fMRI.

mode = cfg.rsa.modality;
if ~any(strcmp(mode,{'corr','regress','multiple_regress'}))
    error('mvpalab:validatersa',...
        ['RSA modality not recognized: ''%s''. Use ''corr'', ' ...
        '''regress'' or ''multiple_regress''.'],mode);
end

if isempty(cfg.rsa.tmodels)
    error('mvpalab:validatersa',...
        'cfg.rsa.tmodels needs at least one theoretical model.');
end

ids = cellfun(@(model) model.id,cfg.rsa.tmodels,'UniformOutput',false);
if numel(unique(ids)) < numel(ids)
    error('mvpalab:validatersa',...
        'Each model in cfg.rsa.tmodels needs its own id.');
end
invalid = find(~cellfun(@isvarname,ids) | ismember(ids,{'rdms','theo'}),1);
if ~isempty(invalid)
    error('mvpalab:validatersa',...
        ['The id ''%s'' of cfg.rsa.tmodels cannot be used: it must be a ' ...
        'valid field name other than ''rdms'' and ''theo''.'],ids{invalid});
end

npairs = nconds*(nconds - 1)/2;
needed = 3;
if strcmp(mode,'multiple_regress'), needed = numel(ids) + 2; end
if ~cfg.rsa.trialwise && npairs < needed
    error('mvpalab:validatersa',...
        ['%d conditions give %d pairs, and the modality ''%s'' with %d ' ...
        'models needs at least %d.'],nconds,npairs,mode,numel(ids),needed);
end

for m = 1 : numel(ids)
    mdl = cfg.rsa.tmodels{m}.mdl;
    square = isequal(size(mdl),[nconds nconds]);
    if ~(isnumeric(mdl) || islogical(mdl)) || ~square
        error('mvpalab:validatersa',...
            ['The model ''%s'' must be a [%d x %d] matrix, one row and ' ...
            'column per condition, and it is [%s].'],ids{m},nconds,...
            nconds,num2str(size(mdl)));
    end
    mdl = (double(mdl) + double(mdl)')/2;
    values = mdl(tril(true(nconds),cfg.rsa.trialwise - 1));
    if numel(unique(values)) < 2
        error('mvpalab:validatersa',...
            ['All the values of the model ''%s'' are equal, so its ' ...
            'correlation or regression with the RDMs is NaN.'],ids{m});
    end
end

for field = {'nfolds','nreps'}
    n = cfg.rsa.(field{1});
    if ~isscalar(n) || n < 1 || n ~= round(n)
        error('mvpalab:validatersa',...
            'cfg.rsa.%s must be a whole number of at least 1.',field{1});
    end
end

if cfg.rsa.nfolds == 1 && strcmp(cfg.rsa.distance,'crossnobis')
    error('mvpalab:validatersa',...
        ['The crossnobis distance is cross-validated and requires ' ...
        'cfg.rsa.nfolds > 1. Use cfg.rsa.distance = ''mahalanobis'' ' ...
        'without cross-validation.']);
end

if cfg.rsa.nfolds > 1 && cfg.rsa.trialwise
    error('mvpalab:validatersa',...
        ['Cross-validated RDMs (cfg.rsa.nfolds > 1) require ' ...
        'condition-wise RDMs (cfg.rsa.trialwise = false). Set ' ...
        'cfg.rsa.nfolds = 1 to compute trial-wise RDMs.']);
end

mvpalab_validatesupertrials(cfg);
mvpalab_validatestats(cfg);
mvpalab_validatesignflip(cfg);

if ~isscalar(cfg.normdata) || ~ismember(cfg.normdata,0:4)
    error('mvpalab:validatersa','cfg.normdata must be 0, 1, 2, 3 or 4.');
end
if cfg.normdata >= 3
    warning('mvpalab:validatersa',...
        ['cfg.normdata = %d is only applied by the classifiers ' ...
        '(MVPA and MVCC) and has no effect in RSA. Use cfg.normdata = 1 ' ...
        'or 2 (applied to each trial or supertrial) or 0.'],cfg.normdata);
end
if strcmp(cfg.dimred.method,'pca')
    warning('mvpalab:validatersa',...
        ['cfg.dimred is only applied by the classifiers (MVPA and MVCC): ' ...
        'the RDMs use all the channels or voxels.']);
end

end
