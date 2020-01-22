function [res,cfg] = roc_analysis(cfg,fv )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing ROC: </strong>\n');
%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    tic; fprintf(['   - Subject: ' int2str(sub) '/' int2str(length(cfg.subjects)) ' >> ']);
    X = fv.X{sub}.a; Y = fv.Y{sub}.a;
    %% Stratified partition for cross validation:
    strpar = cvpartition(Y,'KFold',cfg.analysis.nfolds);
    
    %% Timepoints loop
    if cfg.analysis.parcomp
        c = cfg.analysis;
        parfor tp = 1 : c.ntp
            [...
                x{sub,tp},...
                y{sub,tp},...
                t{sub,tp},...
                auc(tp,:),...
                cr(tp,:),...
                cm{sub,tp}...
                ] = roc_classifier(X,Y,tp,c,strpar);
        end
    else
        for tp = 1 : cfg.analysis.ntp
            [x{sub,tp},y{sub,tp},t{sub,tp},auc(tp,:),cr(tp,:),cm{sub,tp}] = ...
                roc_classifier(X,Y,tp,cfg.analysis,strpar);
        end
    end
    
    if isrow(auc)
        res_auc(:,:,sub) = auc;
        res_cr(:,:,sub) = cr;
    else
        res_auc(:,:,sub) = auc';
        res_cr(:,:,sub) = cr';
    end
    toc
end
res.x = x;
res.y = y;
res.t = t;
res.auc = res_auc;
res.cr = res_cr;
res.cm = cm;

fprintf(' - Done!\n');
end



