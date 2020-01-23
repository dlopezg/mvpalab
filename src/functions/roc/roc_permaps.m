function [permuted_maps,cfg] = roc_permaps(cfg,fv )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing ROC permutated maps: </strong>\n');
cfg.analysis.permlab = true;
%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(length(cfg.subjects)) ' >> ']);
    X = fv.X{sub}.a; Y = fv.Y{sub}.a;
    
    for i = 1 : cfg.stats.nper
        %% Stratified partition for cross validation:
        tic; strpar = cvpartition(Y,'KFold',cfg.analysis.nfolds);
        
        %% Timepoints loop
        c = cfg.analysis;
        if cfg.analysis.parcomp
            parfor tp = 1 : c.ntp
                [~,~,~,auc(tp,:),~,~] = roc_classifier(X,Y,tp,c,strpar);
            end
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        else
            for tp = 1 : cfg.analysis.ntp
                [~,~,~,auc(tp,:),~,~] = roc_classifier(X,Y,tp,c,strpar);
            end
            fprintf(['     - Permutation: ' int2str(i) ' > ']);
        end
        
        if isrow(auc)
            permuted_maps(:,:,i,sub) = auc;
        else
            permuted_maps(:,:,i,sub) = auc';
        end
        toc
        
    end
end

cfg.analysis.permlab = false;
fprintf(' - Done!\n');
end



