function dataset = mvpalab_averagetrials(cfg,dataset)
%% MVPALAB_AVERAGETRIALS
%
%  This function combines trials belonging to the same condition by
%  averaging them, if trialwise analysis is not selected.
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

    % Initialize label vector:
    train_y = []; test_y = [];

    % Iterate over conditions:
    for i = 1 : length(unique(dataset.train_y))

        % Average trials per condition:
        train_x_averaged(i,:,:) =  mean(dataset.train_x(...
            double(dataset.train_y(:,1)) == i,:,:),1);
        test_x_averaged(i,:,:) =  mean(dataset.test_x(...
            double(dataset.test_y(:,1)) == i,:,:),1);

        % Generate new label vector:
        train_y = [train_y; i];
        test_y = [test_y; i];

    end

    % Update dataset:
    dataset.train_x = train_x_averaged; 
    dataset.train_y = categorical(train_y);
    dataset.test_x = test_x_averaged; 
    dataset.test_y = categorical(test_y);
    
end

