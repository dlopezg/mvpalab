function [train_X,test_X,params,cfg] = mvpalab_dimred(train_X,train_Y,test_X,test_Y,cfg)

if strcmp(cfg.dimred.method,'pca')
    [coeff,scores,~,~,var,mu] = pca(train_X);
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

