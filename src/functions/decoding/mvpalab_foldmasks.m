function masks = mvpalab_foldmasks(cfg,Y)
%% MVPALAB_FOLDMASKS
%
%  This function draws a stratified cross-validation partition of one
%  dataset and returns the training trials of each fold: cfg.cv.nfolds
%  folds, or one fold per trial with cfg.cv.method = 'loo'. The number of
%  trials is the one of the current repetition, so it follows the
%  supertrials.
%
%  Within one dataset (MVPA) the test trials of each fold are the others.
%  Across datasets (MVCC) each fold uses these masks of each dataset, the
%  training dataset to train and the test dataset to test (see
%  mvpalab_dirpartition).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.cv.method and cfg.cv.nfolds).
%
%  - {1D-array} - Y:
%    Labels of the dataset.
%
%%  OUTPUT:
%
%  - {2D-array} - masks:
%    Logical matrix [trials x folds].

nfolds = cfg.cv.nfolds;
if strcmp(cfg.cv.method,'loo'), nfolds = numel(Y); end

strpar = cvpartition(Y,'KFold',nfolds);

masks = false(strpar.NumObservations,strpar.NumTestSets);
for k = 1 : strpar.NumTestSets
    masks(:,k) = strpar.training(k);
end

end
