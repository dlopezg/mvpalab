function [ out_data,cfg] = mvpalab_fext ( cfg, data, sub )
%% MVPALAB_FEXT
%
%  This function generates the feature vectors of one subject from the
%  data of each class: the power envelope if cfg.feature = 'envelope' (see
%  mvpalab_powenvelope), the smoothing (see mvpalab_preproc), the class
%  sizes and the normalization (see mvpalab_adjustclasses) and the data
%  matrix and the labels (see mvpalab_datalabels).
%
%  With supertrials (cfg.trialaver.flag) the feature vectors keep the
%  single trials and the class sizes and the normalization are applied to
%  the supertrials of each repetition (see mvpalab_supertrials). Then
%  cfg.trialaver.ntrials must be at least 1 and each class needs at least
%  cfg.trialaver.ntrials trials; otherwise it gives an error.
%
%  It also changes cfg:
%  - cfg.classsize.matchkfold is disabled in MVCC.
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
%    Data of the subject, one cell per dataset (see mvpalab_readdata).
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

%% Initialize:
X = cell(length(cfg.study.dataFiles{1,1}),1);
Y = X;

%% Check the size of the supertrials:
if cfg.trialaver.flag && cfg.trialaver.ntrials < 1
    error('cfg.trialaver.ntrials must be at least 1 to average trials.');
end

%% Match class size (factor of k) is not needed for MVCC:
if size(data,2) > 1
    cfg.classsize.matchkfold = false;
end

%% Context loop:
for ctxt = 1 : size(data,2)
    % Extract classes:
    classes = data{ctxt};
    class_names = fieldnames(classes);
    
    %% Classes loop:
    for class = 1 : length(class_names)
        fprintf('\n    <strong> - Generating feature vectors:</strong> ');
        fprintf([class_names{class} '\n']);
        data_ = classes.(class_names{class});
        
        % Power envelope as a feature if needed:
        if isfield(cfg,'feature') && strcmp(cfg.feature,'envelope')
           [cfg, data_] = mvpalab_powenvelope(cfg,data_);
        end
        
        fv{ctxt,class} = mvpalab_preproc(cfg,data_);
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

c = 1;
for ctxt = 1 : size(fv,1)
    for class = 1 : size(fv,2)
        cfg.datalength(sub,c) = size(fv{ctxt,class},1);
        c = c + 1;
    end
end


%% Data and labels:
[X,Y,cfg] = mvpalab_datalabels(cfg,fv);
out_data.X = X;
out_data.Y = Y;

%  mvpalab_checkfv needs to know that they are not supertrials:
if cfg.trialaver.flag, out_data.singletrials = true; end

%% Update nfolds if LOOCV:
if strcmp(cfg.cv.method,'loo')
    dataset.a.X = X.a;
    dataset.a.Y = Y.a;
    dataset = mvpalab_supertrials(cfg,dataset);
    cfg.cv.loo(sub) = size(dataset.a.X,1);
end

fprintf('\n');

end