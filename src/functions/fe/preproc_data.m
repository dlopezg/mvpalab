function [ data ] = preproc_data( cfg, data )
%PREPROC_DATA Summary of this function goes here
%   Detailed explanation goes here

%% Smooth data:

if isfield(cfg.fe,'smooth')
    if cfg.fe.smooth.flag
        data = smoothdata(data,2,cfg.fe.smooth.method,...
            cfg.fe.smooth.window);
    end
end

%% Average trials if needed:

if isfield(cfg.fe,'strial')
    if cfg.fe.strial.flag
        for i = 1 : floor(size(data,3)/cfg.fe.strial.ntrials)
            idxs = randperm(size(data,3),cfg.fe.strial.ntrials);
            super_trials(:,:,i) = mean(data(:,:,idxs),3);
            data(:,:,idxs) = [];
        end
        data = super_trials; clear super_trials;
    end
end

%% Adjust class size (factor of k):

if isfield(cfg.fe,'matchc')
    if cfg.fe.matchc.flag
        data = data(:,:,1:floor(size(data,3)/...
            cfg.fe.matchc.nfolds)*cfg.fe.matchc.nfolds);
    end
end

%% Z-SCORE normalization:

if isfield(cfg.fe,'zscore')
    if cfg.fe.zscore.flag && cfg.fe.zscore.dim ~= 3
        data = zscore(data,[],2);
    end
end

%% Generate input vectors:

data = permute(data,[3 1 2]);

end

