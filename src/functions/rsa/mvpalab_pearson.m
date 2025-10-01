function r = mvpalab_pearson(train,test,cfg)

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

