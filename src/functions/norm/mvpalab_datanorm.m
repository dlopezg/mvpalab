function [train_X,test_X,params] = mvpalab_datanorm(cfg,train_X,test_X,params)
%MVPALAB_DATANORM Summary of this function goes here
%   Detailed explanation goes here

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

