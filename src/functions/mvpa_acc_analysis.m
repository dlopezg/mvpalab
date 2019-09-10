function [ acc ,cfg ] = mvpa_acc_analysis( cfg, fv, permute )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing correct rate: </strong>\n');
%% Subjects loop:
nsub = length(cfg.subjects);
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) ' >> ']);
    %% Data and true labels:
    tic
    [X,Y,~,~,cfg] = data_labels(cfg,fv(sub,:));
    
    %% Train and test de classifier with original labels:
    strpar = cvpartition(Y,'KFold',cfg.mvpa.nfolds);
    
    %% Compute PCA if needed:
    
    if cfg.pca.flag
        for tp = 1 : size(X,3)
            [coeff(:,:,tp),...
                scores(:,:,tp),...
                latent(:,:,tp)] = pca(X(:,:,tp));
        end
        X = scores(:,1:cfg.pca.ncom,:);
        clear coeff scores latent
    elseif cfg.pls.flag
        for tp = 1 : size(X,3)
            [xl(:,:,tp),...
                yl{tp},...
                xs(:,:,tp),...
                ys(:,:,tp),...
                beta(:,:,tp),...
                pctvar{tp},...
                mse{tp},...
                stats{tp}] = plsregress(X(:,:,tp),Y,cfg.pls.ncom);
            
            w = stats{tp}.W;
            for i = 1:length(Y)
                XS(i,:,tp)= X(i,:,tp)*w;
            end
        end
        X = XS;
        clear xl yl XS xs ys beta pctvar mse stats
    end
    
    if cfg.mvpa.parcomp
        %% Timepoints loop
        c = cfg.mvpa;
        parfor tp = 1 : c.ntp
            correct_rate(tp,:) = mvpa_svm_classifier(X,Y,tp,c,strpar,permute);
        end
    else
        for tp = 1 : cfg.mvpa.ntp
            correct_rate(tp,:) = mvpa_svm_classifier(X,Y,tp,cfg.mvpa,strpar,permute);
        end
    end
    
    if isrow(correct_rate)
        acc(:,:,sub) = correct_rate;
    else
        acc(:,:,sub) = correct_rate';
    end
    
    toc
    
end
fprintf(' - Done!\n');
end

