function [cr,cfg] = cr_analysis(cfg,fv)
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing correct rate: </strong>\n');
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
            [correct_rate(tp,:),params{sub,tp}] = cr_classifier(X,Y,tp,c,strpar);
        end
    else
        for tp = 1 : cfg.analysis.ntp
            [correct_rate(tp,:),params{sub,tp}] = cr_classifier(X,Y,tp,cfg.analysis,strpar);
        end
    end
    
    if isrow(correct_rate)
        cr(:,:,sub) = correct_rate;
    else
        cr(:,:,sub) = correct_rate';
    end
    toc
end
cfg.analysis.pca.params = params;
fprintf(' - Done!\n');
end

