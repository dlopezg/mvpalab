function [ data ] = mvpalab_preproc( cfg, data )
%PREPROC_DATA Summary of this function goes here
%   Detailed explanation goes here

%% Smooth data:
if ~strcmp(cfg.smoothdata.method,'none')
    fprintf('       # Smoothing the data... ');
    data = mvpalab_smoothdata(cfg,data);
    fprintf('Done.\n');
end

%% Generate input vectors:
data = permute(data,[3 1 2]);
fprintf('       # Done.\n');

end

