function rdm = mvpalab_cvmahalanobis(cfg, X, dims)
%% MVPALAB_CVMAHALANOBIS
%
%  This function computes the Representational Dissimilarity Matrix with cross-validated Mahalanobis distance.
%  The number of folds can be set in cfg.rsa.cvFolds. 
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {2D-matrix} - X:
%    Data matrix for an individual subject containing all the trials and
%    conditions. [trials x channels]
%
%  - {1D-array} - dims:
%    Dimensions of the subject_betas (only for fMRI). [rows, columns] = [regions, runs]
%
%
%%  OUTPUT:
%
%  - {2D-matrix} - rdm:
%    Representational Dissimilarity Matrix:
%    [trials x trials] or [n_conditions x n_conditions]

if strcmp(cfg.analysis, 'rsa-roi')
    k = cfg.rsa.cvFolds;
    numRuns = dims(2);
    trialsPerRun = dims(1);

    if k < numRuns
        k = numRuns;
        warning('The number of folds must be greater than or equal to the number of runs, setting the number of folds to %d.', k);
    end

    if mod(k, numRuns) ~= 0
        k = k - mod(k, numRuns);
        warning('The number of folds is not a multiple of the number of runs, reducing the number of folds to %d.', k);
    end

    runs = cell(numRuns, 1); % Initialize the cell array to hold run data
    for runIndex = 1:numRuns
        % Calculate the start and end indices for slicing X
        startIndex = (runIndex - 1) * trialsPerRun + 1;
        endIndex = runIndex * trialsPerRun;
            
        % Check if X has enough rows for the current run
        if endIndex > size(X, 1)
            error('Not enough data for the specified number of trials per run.');
        end
            
        % Slice X for the current run and assign it to the runs cell array
        runs{runIndex} = X(startIndex:endIndex, :);
    end

        
else
    numRuns = cfg.rsa.cvFolds;
    runs = cell(numRuns, 1);
    trialsPerRun = ceil(size(X, 1) / numRuns);  % Calculate trials per run to handle non-even division
    for i = 1:numRuns
        startIdx = (i - 1) * trialsPerRun + 1;
        endIdx = min(i * trialsPerRun, size(X, 1));  % Ensure we do not exceed the number of trials
        runs{i} = X(startIdx:endIdx, :);
    end
end

% Initialize the RDM matrix
rdm = zeros(numRuns, size(X, 1), size(X, 1));

% Iterate over each run for the test set
for testRunIndex = 1:numRuns
    testIdx = (testRunIndex - 1) * trialsPerRun + 1:min(testRunIndex * trialsPerRun, size(X, 1));
    testData = runs{testRunIndex};

    % Combine the remaining runs for the training set
    trainData = [];
    trainIdx = [];
    for trainRunIndex = 1:numRuns
        if trainRunIndex == testRunIndex
            continue; % Skip if the test run and train run are the same
        end
        currentRunData = runs{trainRunIndex};
        trainData = [trainData; currentRunData];
        startIdx = (trainRunIndex - 1) * trialsPerRun + 1;
        endIdx = min(trainRunIndex * trialsPerRun, size(X, 1));
        trainIdx = [trainIdx, startIdx:endIdx];
    end

    covTrain = mvpalab_computecovmat(trainData);
    %distMatrix = pdist2(X, X, 'mahalanobis', covTrain);
    distMatrix = mvpalab_computemahalanobis(X, covTrain); 
    % save dist matrix in first fold of rdm
    rdm(testRunIndex, :, :) = distMatrix;
end
% Average the RDMs across the folds
rdm = squeeze(mean(rdm, 1));
 
