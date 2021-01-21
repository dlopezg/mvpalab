function [ data ] = mvpalab_preproc( cfg, data )
%PREPROC_DATA Summary of this function goes here
%   Detailed explanation goes here

%% Smooth data:
if cfg.smoothdata.flag
    fprintf('       # Smoothing the data... ');
    data = smoothdata(data,2,cfg.smoothdata.method,cfg.smoothdata.window);
    fprintf('Done.\n');
end

%% Average trials if needed:
if cfg.trialaver.flag
    fprintf('       # Generating supertrials... ');
    for i = 1 : floor(size(data,3)/cfg.trialaver.ntrials)
        if strcmp(cfg.trialaver.order,'rand')
            idxs = randperm(size(data,3),cfg.trialaver.ntrials);
        else
            idxs = (1:cfg.trialaver.ntrials);
        end
        super_trials(:,:,i) = mean(data(:,:,idxs),3);
        data(:,:,idxs) = [];
    end
    data = super_trials; clear super_trials;
    fprintf('Done.\n');
end

%% Adjust class size (factor of k):
if cfg.classize.matchkfold && strcmp(cfg.cv.method,'kfold')
    fprintf('       # Adjusting class size (factor of k)... ');
    data = data(:,:,1:floor(size(data,3)/...
        cfg.cv.nfolds)*cfg.cv.nfolds);
    fprintf('Done.\n');
end

%% Z-SCORE normalization:
if cfg.normdata && cfg.normdata < 3
    fprintf('       # Data normalization... ');
    data = zscore(data,[],cfg.normdata);
    fprintf('Done.\n');
end

%% Generate input vectors:
data = permute(data,[3 1 2]);
fprintf('       # Done.\n');

end

