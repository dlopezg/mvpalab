function [train_X,test_X,params] = mvpalab_datanorm(cfg,train_X,test_X,params)
%% MVPALAB_DATANORM
%
%  This function normalizes the data of one cross-validation fold with the
%  method in cfg.normdata:
%
%  - 3: z-score across trials (zscore).
%  - 4: z-score across trials with the standard deviation normalized by
%    the number of trials (see mvpalab_stdnorm).
%
%  The mean and the standard deviation of each feature are computed in the
%  training set and applied to both sets. Features with a standard
%  deviation of 0 are divided by 1. If params is not empty, only test_X is
%  normalized, with those parameters, and train_X is returned unchanged.
%  With cfg.normdata = 0, 1 or 2 the data is returned unchanged: values 1
%  and 2 are applied to each trial when the data is imported or, with
%  supertrials, to each supertrial (see mvpalab_adjustclasses).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.normdata).
%
%  - {matrix} - train_X:
%    Training data [trials x features].
%
%  - {matrix} - test_X:
%    Test data [trials x features].
%
%  - {struct} - params:
%    Parameters of a previous call, or [] to compute them in train_X.
%
%%  OUTPUT:
%
%  - {matrix} - train_X:
%    Normalized training data [trials x features].
%
%  - {matrix} - test_X:
%    Normalized test data [trials x features].
%
%  - {struct} - params:
%    Mean (u) and standard deviation (v) of each feature in the training
%    set [1 x features].

if ~cfg.normdata
    return
elseif cfg.normdata == 3
    % Parameters computed in the training set and applied to the test set:
    if isempty(params)
        [train_X,params.u,params.v] = zscore(train_X,[],1);
        params.v(params.v == 0) = 1;
    end
    test_X = (test_X-params.u)./params.v;
elseif cfg.normdata == 4
    [train_X, test_X, params] = mvpalab_stdnorm(train_X,test_X,params);
end

end

