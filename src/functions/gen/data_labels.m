function [ Xa,Ya,Xb,Yb,cfg ] = data_labels( cfg,fv )
%DATA_LABELS Summary of this function goes here
%   Detailed explanation goes here

Xa = [fv{1};fv{2}];
Ya = logical([zeros(size(fv{1},1),1);ones(size(fv{2},1),1)]);
Xb = [];
Yb = [];

if length(fv) > 2 % MVCC
    Xb = [fv{3};fv{4}];
    Yb = logical([zeros(size(fv{3},1),1);ones(size(fv{4},1),1)]);
end
end