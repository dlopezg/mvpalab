function masks = mvpalab_trainfolds(cfg,Y)
%% MVPALAB_TRAINFOLDS
%
%  This function draws a stratified cross-validation partition and returns
%  the training trials of each fold. See mvpalab_cvpartitions for the use of
%  these trials in each analysis.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.cv.nfolds).
%
%  - {1D-array} - Y:
%    Labels of the dataset.
%
%%  OUTPUT:
%
%  - {2D-array} - masks:
%    Logical matrix [trials x folds].

strpar = cvpartition(Y,'KFold',cfg.cv.nfolds);

masks = false(strpar.NumObservations,strpar.NumTestSets);
for k = 1 : strpar.NumTestSets
    masks(:,k) = strpar.training(k);
end

end
