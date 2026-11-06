function [ out_data,cfg] = mvpalab_fext ( cfg, data, sub )
% FEATURE_EXTRACTION This function generates the feature vectors.
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