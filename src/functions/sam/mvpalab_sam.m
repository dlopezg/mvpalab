function [res,cfg] = mvpalab_sam(cfg,fv)

fprintf('<strong> > Computing SAM analysis: </strong>\n');

%% Initialization
nSubjects = length(cfg.study.dataFiles{1,1});
load sam_upperbound;
cfg.sam.upperbound = upperbounds; 

%% Subjects loop:
for sub = 1 : nSubjects
    tic;
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nSubjects) ' >> ']);
    
    X = fv{sub}.X.a;
    Y = fv{sub}.Y.a;
    
    %% Timepoints loop
    if cfg.classmodel.parcomp
        parfor tp = 1 : cfg.tm.ntp
            [acc(tp,:), w{1,tp,sub}]...
                = mvpalab_sameval(X,Y,tp,cfg);
        end
    else
        for tp = 1 : cfg.tm.ntp
            [acc(tp,:), w{1,tp,sub}]...
                = mvpalab_sameval(X,Y,tp,cfg);
        end
    end
    
    % Upper bound:
    upperb = upperbounds.gbound(10 + size(X,1),cfg.dimred.ncomp);
    % Reestructure result:
    if cfg.classmodel.tempgen
        res.acc(:,:,sub) = acc - upperb;
    else
        res.acc(:,:,sub) = acc' - upperb;
    end
    toc;
end

cfg.sam.bound = upperb;

% Return confusion matrix if needed:
if cfg.classmodel.confmat
    res.confmat = mvpalab_reorganize_(cfg,confmat);
end

% Return wvector if needed:
if cfg.classmodel.wvector
    res.wvector = mvpalab_reorganize_weights(w);
end

% Save result
if ~cfg.sf.flag
    mvpalab_saveresults(cfg,res);
end

fprintf(' - Done!\n');
end



