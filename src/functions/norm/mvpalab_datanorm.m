function [train_X,test_X,params] = mvpalab_datanorm(cfg,train_X,test_X,params)
%MVPALAB_DATANORM Summary of this function goes here
%   Detailed explanation goes here

if ~cfg.normdata
    return
elseif cfg.normdata == 3
    train_X = zscore(train_X,[],1);
    test_X = zscore(test_X,[],1);
elseif cfg.normdata == 4
    [train_X, test_X, params] = mvpalab_stdnorm(train_X,test_X,params);
end

end

