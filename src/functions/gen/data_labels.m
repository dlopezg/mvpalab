function [X,Y,cfg] = data_labels(cfg,fv)
%DATA_LABELS Summary of this function goes here
%   Detailed explanation goes here
    X.a = [fv{1};fv{2}];
    Y.a = logical([zeros(size(fv{1},1),1);ones(size(fv{2},1),1)]);
    if length(fv) > 2
        X.b = [fv{3};fv{4}];
        Y.b = logical([zeros(size(fv{3},1),1);ones(size(fv{4},1),1)]);
    end
end