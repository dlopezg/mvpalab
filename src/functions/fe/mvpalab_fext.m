function [out_data,cfg] = mvpalab_fext(cfg,data,sub)
%% MVPALAB_FEXT
%
%  This function generates the feature vectors of one subject from the
%  data of each class: the features of each class (see mvpalab_preproc),
%  the class sizes and the normalization (see mvpalab_adjustclasses) and
%  the data matrix and the labels (see mvpalab_datalabels).
%
%  With supertrials (cfg.trialaver.flag) the feature vectors keep the
%  single trials and the class sizes and the normalization are applied to
%  the supertrials of each repetition (see mvpalab_supertrials). Then each
%  class needs at least cfg.trialaver.ntrials trials; otherwise it gives an
%  error.
%
%  It also changes cfg:
%  - cfg.datalength(sub,:): number of trials of each class in the feature
%    vectors, first those of dataset A and then those of dataset B.
%  - cfg.cv.loo(sub): with cfg.cv.method = 'loo', the number of
%    observations of dataset A (supertrials, if enabled), used as the
%    number of folds (see mvpalab_loadfv).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - data:
%    Data of the subject, one cell per dataset (see mvpalab_classdata).
%    Each cell is a structure with one field per class, named after
%    cfg.study.conditionIdentifier without spaces, with the data
%    [channels x timepoints x trials].
%
%  - {int} - sub:
%    Subject.
%
%%  OUTPUT:
%
%  - {struct} - out_data:
%    Data matrices (X) and categorical labels (Y), with the fields a and,
%    in MVCC, b (see mvpalab_datalabels). X: [trials x channels x
%    timepoints]. With supertrials, also singletrials = true (see
%    mvpalab_checkfv).
%
%  - {struct} - cfg:
%    Configuration structure, with the changes above.

%% Features of each class:
for ctxt = 1 : numel(data)
    class_names = fieldnames(data{ctxt});
    for class = 1 : numel(class_names)
        fprintf('\n    <strong> - Generating feature vectors:</strong> ');
        fprintf([class_names{class} '\n']);
        fv{ctxt,class} = mvpalab_preproc(cfg,data{ctxt}.(class_names{class}));
        if cfg.trialaver.flag && size(fv{ctxt,class},1) < cfg.trialaver.ntrials
            error('Class %s has fewer trials than cfg.trialaver.ntrials.',...
                class_names{class});
        end
    end
end

%% Class sizes and normalization:
%  With supertrials they are applied to the supertrials of each repetition
%  (see mvpalab_supertrials) and the feature vectors keep the single trials.
if ~cfg.trialaver.flag
    fv = mvpalab_adjustclasses(cfg,fv);
end

nobs = cellfun(@(class) size(class,1),fv');
cfg.datalength(sub,:) = nobs(:)';

%% Data and labels:
[out_data.X,out_data.Y] = mvpalab_datalabels(fv);

%  mvpalab_checkfv needs to know that they are not supertrials:
if cfg.trialaver.flag, out_data.singletrials = true; end

%% Update nfolds if LOOCV:
if strcmp(cfg.cv.method,'loo')
    dataset.a.X = out_data.X.a;
    dataset.a.Y = out_data.Y.a;
    dataset = mvpalab_supertrials(cfg,dataset);
    cfg.cv.loo(sub) = size(dataset.a.X,1);
end

fprintf('\n');

end
