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

if cfg.rsa.nfolds > 1
    %  Cross-validated RDMs compare the pattern of each condition in the
    %  training set with the pattern of each condition in the test set, so
    %  they are only defined for condition-wise RDMs. In trial-wise RDMs the
    %  training and test trials are different trials.
    if cfg.rsa.trialwise
        error(['Cross-validated RDMs (cfg.rsa.nfolds > 1) require ' ...
            'condition-wise RDMs (cfg.rsa.trialwise = false). Set ' ...
            'cfg.rsa.nfolds = 1 to compute trial-wise RDMs.']);
    end
    strpar = cvpartition(Y,"KFold",cfg.rsa.nfolds);
else
    strpar = false;
end

%% Iterate over folds
for k = 1 : cfg.rsa.nfolds
    %% Split the data in train and test folds:
    %  Fold k is the test set and the trials of the remaining folds are the
    %  training set:

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
%  Each fold is used once as test set. As in MNE-RSA (compute_rdm_cv), the
%  cross-validated RDM is the average of the RDMs of all the folds.
if cfg.rsa.nfolds > 1
    rdms = mean(rdms,4);
end

rdm.rdm = rdms;
rdm.labels = dataset.test_y;

fprintf('- Done.\n\n');

end

