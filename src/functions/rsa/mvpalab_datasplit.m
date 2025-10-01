function [data] = mvpalab_datasplit(cfg,X,Y,strpar,k)
%% MVPALAB_DATASPLIT
%
%  This function splits the data into training and testing sets based on
%  the specified cross-validation configuration and the current fold.
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
%  - {struct} - strpar:
%    Structure containing the trial indices for each fold.
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
%      - data.train_y: Labels for the training data
%      - data.test_x:  Testing data matrix  [trials x channels x timepoints]
%      - data.test_y:  Labels for the testing data

if cfg.cv.nfolds > 1
    
    % Generate folds index vector
    fold_idxs = (1:cfg.cv.nfolds);

    % Not selected folds:
    rest_folds = fold_idxs(fold_idxs ~= k);

    % Select actual (test) folds:
    data.test_x = X(strpar.test(k),:,:);
    data.test_y = Y(strpar.test(k));

    % Select remaining folds:
    for fold = 1 : length(rest_folds)
        data.train_x(:,:,:,fold) = X(strpar.test(rest_folds(fold)),:,:);
        data.train_y(:,fold) = Y(strpar.test(rest_folds(fold)));
    end

    % Compute the mean across folds
    data.train_x = mean(data.train_x,4);

else

    % If no CV the train and set data remains the same.
    data.train_x = X;  data.train_y = Y; 
    data.test_x = X;   data.test_y = Y;
end


end