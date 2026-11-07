function [train_X,test_X,params,cfg] = mvpalab_dimred(train_X,train_Y,test_X,test_Y,cfg)
%% MVPALAB_DIMRED
%
%  This function reduces the dimension of the data of one cross-validation
%  fold with the method in cfg.dimred.method. Only 'pca' is implemented:
%  the principal components are computed in the training set, the test set
%  is projected in the same space (see also mvpalab_project) and both keep
%  the first cfg.dimred.ncomp components. cfg.dimred.ncomp must be between
%  1 and the number of components; otherwise it gives an error. The
%  methods 'pls' and 'lda' are not implemented.
%
%%  INPUT:
%
%  - {matrix} - train_X:
%    Training data [trials x features].
%
%  - {matrix} - train_Y:
%    Categorical labels of the training trials (not used by PCA).
%
%  - {matrix} - test_X:
%    Test data [trials x features].
%
%  - {matrix} - test_Y:
%    Categorical labels of the test trials (not used by PCA).
%
%  - {struct} - cfg:
%    Configuration structure (cfg.dimred).
%
%%  OUTPUT:
%
%  - {matrix} - train_X:
%    Training data in the principal component space
%    [trials x cfg.dimred.ncomp].
%
%  - {matrix} - test_X:
%    Test data in the principal component space
%    [trials x cfg.dimred.ncomp].
%
%  - {struct} - params:
%    PCA parameters of the training set: coeff (coefficients of all the
%    components), mu (mean of each feature) and var (percentage of the
%    variance explained by each component).
%
%  - {struct} - cfg:
%    Configuration structure, not changed.

if strcmp(cfg.dimred.method,'pca')
    [coeff,scores,~,~,var,mu] = pca(train_X);
    if cfg.dimred.ncomp < 1 || cfg.dimred.ncomp > size(scores,2)
        error('cfg.dimred.ncomp must be between 1 and %d.',size(scores,2));
    end
    train_X = scores(:,1:cfg.dimred.ncomp,:);
    %% Project the test set in the principal component space:
    % When you specify a variable weight, the coefficient matrix is not 
    % orthonormal, but the reconstruction rule is still
    % Xcentered = score*coeff'. To get the score, you would have to do 
    % Xcentered/coeff':
    test_X = test_X - mu;            % Xcentered
    test_scores = test_X/coeff';     % Projected scores
    test_X = test_scores(:,1:cfg.dimred.ncomp,:);
    
    % Return PCA params:
    params.coeff = coeff; params.mu = mu; params.var = var;
    
elseif strcmp(cfg.dimred.method,'pls')
%     [xl,yl,xs,ys,beta,pctvar,mse,stats] = plsregress(train_X,train_Y,...
%         cfg.dimred.ncomp);
%     train_X = xs(:,1:cfg.dimred.ncomp,:);
elseif strcmp(cfg.dimred.method,'lda')
    
end

end

