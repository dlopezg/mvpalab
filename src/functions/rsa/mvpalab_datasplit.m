function [data] = mvpalab_datasplit(cfg,X,Y,strpar,k)
%% MVPALAB_DATASPLIT
%
%  This function splits the data into training and testing sets based on
%  the specified cross-validation configuration and the current fold.
%
%  With cross-validation, fold k is the test set and all the trials of the
%  remaining folds are the training set. The training trials are returned
%  individually (they are not averaged across folds), so that:
%    - The folds can have different numbers of trials (stratified
%      partitions are only balanced up to one trial per condition).
%    - The condition-wise patterns computed by mvpalab_averagetrials are
%      the mean of all the training trials of each condition, i.e. every
%      trial has the same weight (as average_dataset_by in rsatoolbox).
%    - The individual training trials are available, e.g. to estimate the
%      noise covariance from the residuals.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {3D-matrix} - X:
%    Data matrix for an individual subject. [trials x channels x timepoints]
%
%  - {1D-categorical} - Y:
%    Categorical vector including data labels.
%
%  - {cvpartition} - strpar:
%    Stratified partition of the trials into cfg.cv.nfolds folds (not used
%    without cross-validation).
%
%  - {int} - k:
%    Current fold index used to select the test set.
%
%%  OUTPUT:
%
%  - {struct} - data:
%    Structure containing the training and testing datasets:
%
%      - data.train_x: Training data matrix [trials x channels x timepoints]
%      - data.train_y: Labels for the training data [trials x 1]
%      - data.test_x:  Testing data matrix  [trials x channels x timepoints]
%      - data.test_y:  Labels for the testing data [trials x 1]

if cfg.cv.nfolds > 1

    % Test set: trials of fold k.
    data.test_x = X(strpar.test(k),:,:);
    data.test_y = Y(strpar.test(k));

    % Training set: all the trials of the remaining folds.
    data.train_x = X(strpar.training(k),:,:);
    data.train_y = Y(strpar.training(k));

else

    % If no CV the train and set data remains the same.
    data.train_x = X;  data.train_y = Y;
    data.test_x = X;   data.test_y = Y;
end


end
