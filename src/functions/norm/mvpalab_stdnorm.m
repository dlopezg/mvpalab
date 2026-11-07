function [train_X,test_X,params] = mvpalab_stdnorm(train_X,test_X,params)
%% MVPALAB_STDNORM
%
%  This function normalizes the training and test sets with the mean and
%  the standard deviation of each feature in the training set. The
%  standard deviation is normalized by the number of trials,
%  std(train_X,1). Features with a standard deviation of 0 are divided by
%  1. If params is given and not empty, only test_X is normalized, with
%  those parameters, and train_X is returned unchanged. It is used by
%  mvpalab_datanorm with cfg.normdata = 4.
%
%%  INPUT:
%
%  - {matrix} - train_X:
%    Training data [trials x features].
%
%  - {matrix} - test_X:
%    Test data [trials x features].
%
%  - {struct} - params:
%    Optional. Parameters of a previous call, or [] to compute them in
%    train_X.
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

if exist('params','var') && ~isempty(params)
    test_X = (test_X-params.u)./params.v;
else
    params.u = mean(train_X,1);
    params.v = std(train_X,1);
    params.v(params.v == 0) = 1;
    
    %% Data normalization:
    train_X = (train_X-params.u)./params.v;
    test_X = (test_X-params.u)./params.v;
end

end

