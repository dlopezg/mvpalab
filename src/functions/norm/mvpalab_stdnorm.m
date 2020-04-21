function [train_X,test_X,params] = mvpalab_stdnorm(train_X,test_X,params)
%MVPALAB_STDNORM Summary of this function goes here
%   Detailed explanation goes here

if exist('params','var') && ~isempty(params)
    test_X = (test_X-params.u)./params.v;
else
    params.u = mean(train_X,1);
    params.v = std(train_X,1);
    
    %% Data normalization:
    train_X = (train_X-params.u)./params.v;
    test_X = (test_X-params.u)./params.v;
end

end

