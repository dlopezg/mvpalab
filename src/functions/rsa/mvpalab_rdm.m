function rdm = mvpalab_rdm(cfg,X,Y)
%% MVPALAB_RDM
%
%  This function returns the trial-wise Representational Dissimilarity
%  Matrices for each timepoint.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {3D-matrix} - X:
%    Data matrix for an individual subject containing all the trials and
%    conditions. [trials x chanels x timepoints]
%
%  - {1D-categorical} - Y:
%    Categorical vector including data labels
%
%%  OUTPUT:
%
%  - {3D-matrix} - rdm.matrix:
%    Representational Dissimilarity Matrices for each timepoint:
%    [trials x trials x timepoints]
%    [conditions x conditions x timepoints]

%% Print some information:
fprintf('   - Computing neural RDMs:');

%% Number of timepoints:
ntp = size(X,3);

%% Generate partitions
% If a cross-validated measure is selected, the stratified data partition
% is generated here:

if cfg.cv.nfolds > 1
    strpar = cvpartition(Y,"KFold",cfg.cv.nfolds);
else
    strpar = false;
end

%% Iterate over folds
for k = 1 : cfg.cv.nfolds
    %% Split the data in train and test folds:
    % One fold is selected for train and the rest are averaged for testing:
    
    dataset = mvpalab_datasplit(cfg,X,Y,strpar,k);

    %% Average trials if necessary:
    %  This is used to generate condition-wise RDMs:

    dataset = mvpalab_averagetrials(cfg,dataset);

    train_x = dataset.train_x;
    test_x = dataset.test_x;

    %% Construct RDMs using the specified distance measure:

    if cfg.classmodel.parcomp && ntp > 1
        parfor tp = 1 : ntp
            rdms(:,:,tp,k) = mvpalab_computerdm(cfg,train_x(:,:,tp),test_x(:,:,tp), []);
        end
    else
        for tp = 1 : ntp
            rdms(:,:,tp,k) = mvpalab_computerdm(cfg,train_x(:,:,tp),test_x(:,:,tp), []);
        end
    end
end

%% Compute the mean of each fold:
if cfg.cv.nfolds > 1
    rdms = mean(rdms,4);
end

rdm.rdm = rdms;
rdm.labels = dataset.test_y;

fprintf('- Done.\n\n');

end

