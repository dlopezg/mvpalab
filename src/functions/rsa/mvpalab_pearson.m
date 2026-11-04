function r = mvpalab_pearson(train,test,cfg)
%% MVPALAB_PEARSON
%
%  This function computes the Pearson correlation (cfg.rsa.meancenter =
%  true) or the cosine similarity (false) between the columns of train
%  and the columns of test, i.e. between patterns across features. It is
%  used for the Pearson distance without cross-validation (see
%  mvpalab_computerdm).
%
%  Constant patterns: a pattern with the same value in all the features
%  (e.g. a timepoint set to zero in all the channels) is zero after the
%  centering, so its correlations are 0/0 = NaN: the correlation is not
%  defined. Use the Euclidean distance or exclude these timepoints.
%
%%  INPUT:
%
%  - {2D-matrix} - train:
%    Patterns in columns. [features x patterns]
%
%  - {2D-matrix} - test:
%    Patterns in columns. [features x patterns]
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {2D-matrix} - r:
%    Correlation between each pattern of train (rows) and each pattern of
%    test (columns). [patterns x patterns]

    [s_cond(1),s_train] = size(train);
    mean_train = sum(train,1)/s_cond(1); % mean X
    
    
    s_test = size(test,2);
    mean_test = sum(test,1)/s_cond(1);
    

    if cfg.rsa.meancenter
        % Center around 0
        train_centered = train - repmat(mean_train,s_cond(1),1); 
        test_centered = test - repmat(mean_test,s_cond(1),1);

        train = train_centered;
        test = test_centered;

    end
    
    r=train'*test;
    
    normtrain = sqrt(sum(train.^2,1));
    normtest = sqrt(sum(test.^2,1));
    r = r./repmat(normtrain,s_test,1)';
    r = r./repmat(normtest,s_train,1);
    
    ind = find(abs(r)>1);
    r(ind) = r(ind)./abs(r(ind));

end

