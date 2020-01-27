function [ x_train, x_test, params ] = std_norm( x_train, x_test, params )
%STD_NORM Summary of this function goes here
%   Detailed explanation goes here

if exist('params','var')
    x_test = (x_test-params.u)./params.v;
else
    params.u = mean(x_train,1);
    params.v = std(x_train,1);
    
    %% Data normalization:
    x_train = (x_train-params.u)./params.v;
    x_test = (x_test-params.u)./params.v;
end

end

