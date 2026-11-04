function dataset = mvpalab_averagetrials(cfg,dataset)
%% MVPALAB_AVERAGETRIALS
%
%  This function combines trials belonging to the same condition by
%  averaging them, if trialwise analysis is not selected.
%
%  Order of the conditions: the trials are matched by the value of their
%  label (not by the index of its category), so any categorical, numeric
%  or text labels can be used, and unused categories are ignored. Row i of
%  the averaged data is the i-th condition of unique(train_y): the order of
%  categories(Y) for categorical labels, or the sorted values for numeric
%  labels. The theoretical models (cfg.rsa.tmodels) must follow this order.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure. If cfg.rsa.trialwise is false, trials will
%    be averaged by condition.
%
%  - {3D-matrix} - dataset.train/test_x:
%    Data matrix for an individual subject containing all the trials and
%    conditions. [trials x channels x timepoints]
%
%  - {1D-categorical} - dataset.train/test_y:
%    Categorical vector including data labels
%
%%  OUTPUT:
%
%  - {3D-matrix} - combined:
%    Averaged data matrix where trials are grouped by condition.
%    [conditions x channels x timepoints]

%% Combine trials into conditions if necessary:

if ~cfg.rsa.trialwise

    % Conditions present in the training set, in the order of unique.
    % The test set includes the same conditions (see mvpalab_rdm).
    conds = unique(dataset.train_y);
    nconds = numel(conds);

    % Preallocate [conditions x channels x timepoints]. Also keeps the
    % channels in the second dimension when there is a single timepoint
    % (2D data, e.g. fMRI betas).
    train_x_averaged = zeros(nconds,size(dataset.train_x,2),size(dataset.train_x,3));
    test_x_averaged  = zeros(nconds,size(dataset.test_x,2),size(dataset.test_x,3));

    % Iterate over conditions:
    for i = 1 : nconds

        % Average trials per condition:
        train_x_averaged(i,:,:) =  mean(dataset.train_x(...
            dataset.train_y == conds(i),:,:),1);
        test_x_averaged(i,:,:) =  mean(dataset.test_x(...
            dataset.test_y(:,1) == conds(i),:,:),1);

    end

    % Update dataset: condition labels 1..nconds in the same order.
    dataset.train_x = train_x_averaged;
    dataset.train_y = categorical((1:nconds)');
    dataset.test_x = test_x_averaged;
    dataset.test_y = categorical((1:nconds)');

end

