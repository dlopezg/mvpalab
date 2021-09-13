function [acc,w] = mvpalab_sameval(X,Y,tp,cfg)
%This function returns the accuracy of the classifier in a time-resolved way.

raw_weights = [];
w = [];

%% Train and test data:
train_X = X(:,:,cfg.tm.tpoints(tp));
train_Y = Y(:);
test_X = 0;
test_Y = 0;

%% Data normalization if needed:
[train_X,test_X] = mvpalab_datanorm(cfg,train_X,test_X,[]);

%% Permute labels if needed:
if cfg.classmodel.permlab
    train_Y = train_Y(randperm(length(train_Y)));
end

%% Feature selection if needed:
if ~strcmp(cfg.dimred.method,'none')
    warning('off','stats:pca:ColRankDefX');
    [train_X,~,~] = mvpalab_dimred(train_X,train_Y,test_X,test_Y,cfg);
end

%% Train and test the model:
[mdl,raw_weights(:,1)] = mvpalab_train(train_X,train_Y,cfg);

% Correct feature weights:
if cfg.classmodel.wvector
    haufe_weights(:,1) = mvpalab_wcorrect(train_X,raw_weights(:,1));
end

%% Calculate the performance of the model:
L = resubLoss(mdl);
acc = 1 - L;

% Feature weights:
if cfg.classmodel.wvector
    w.raw = mean(raw_weights,2);
    w.haufe_corrected = mean(haufe_weights,2);
end

end