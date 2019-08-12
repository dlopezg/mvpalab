function [ X,Y,cfg ] = data_labels( cfg, fv )
%DATA_LABELS Summary of this function goes here
%   Detailed explanation goes here

if length(fv) > 2 % MVCC
    X.a = [fv{1};fv{2}];
    Y.a = logical([zeros(size(fv{1},1),1);ones(size(fv{2},1),1)]);
    X.b = [fv{2};fv{3}];
    Y.b = logical([zeros(size(fv{2},1),1);ones(size(fv{3},1),1)]);
else % MVPA
    X = [fv{1};fv{2}];
    Y = logical([zeros(size(fv{1},1),1);ones(size(fv{2},1),1)]);
end
end