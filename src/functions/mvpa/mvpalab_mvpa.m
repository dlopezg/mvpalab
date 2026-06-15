function [res,cfg] = mvpalab_mvpa(cfg,fv)

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

fprintf('<strong> > Computing MVPA analysis: </strong>\n');

%% Initialization
nSubjects = length(cfg.study.dataFiles{1,1});

nfreq = 1;
if cfg.sf.flag
    folders = dir([cfg.sf.filesLocation filesep 'fv' filesep 's_*']);
end

%% Subjects loop:
for sub = 1 : nSubjects
    tic;
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nSubjects) ' >> ']);
    
    if cfg.sf.flag
        fprintf(' Frequency bands - ');
        folder = [folders(sub).folder filesep folders(sub).name];
        files = dir([folder filesep 'ffv_*.mat']);
        nfreq = length(cfg.sf.freqvec);
    end
    
    %% Frequencies loop:
    for freq = 1 : nfreq
        
        %% Load data if needed:
        if cfg.sf.flag
            mvpalab_pcounter(freq,length(files));
            file = [files(freq).folder filesep files(freq).name];
            load(file);
            X = fv.X.a; Y = fv.Y.a;
        else
            X = fv{sub}.X.a; Y = fv{sub}.Y.a;
        end
        
        %% Electrode selection:
        [X,cfg] = mvpalab_chanselection(X,cfg);

        %% Number of cross-validation repetitions (k-fold only):
        nreps = 1;
        if strcmp(cfg.cv.method,'kfold')
            nreps = cfg.cv.nreps;
        end

        %% Repeated cross-validation accumulators:
        acc_r = []; auc_r = [];
        cm_r = cell(cfg.tm.ntp,nreps);
        pr_r = cell(cfg.tm.ntp,nreps);
        re_r = cell(cfg.tm.ntp,nreps);
        f1_r = cell(cfg.tm.ntp,nreps);

        if nreps > 1, fprintf(' Repetition: '); end

        %% Repeated cross-validation loop:
        for rep = 1 : nreps

            %% Stratified partition for cross validation:
            if strcmp(cfg.cv.method,'loo')
                cfg.cv.nfolds = cfg.cv.loo(sub);
            end

            strpar = cvpartition(Y,'KFold',cfg.cv.nfolds);

            %% Timepoints loop
            if cfg.classmodel.parcomp
                parfor tp = 1 : cfg.tm.ntp
                    [...
                        x{sub,tp,freq},...
                        y{sub,tp,freq},...
                        t{sub,tp,freq},...
                        auc(tp,:),...
                        acc(tp,:),...
                        cm_r{tp,rep},...
                        pr_r{tp,rep},...
                        re_r{tp,rep},...
                        f1_r{tp,rep},...
                        w{1,tp,sub,freq}...
                        ] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
                end
            else
                for tp = 1 : cfg.tm.ntp
                    [...
                        x{sub,tp,freq},...
                        y{sub,tp,freq},...
                        t{sub,tp,freq},...
                        auc(tp,:),...
                        acc(tp,:),...
                        cm_r{tp,rep},...
                        pr_r{tp,rep},...
                        re_r{tp,rep},...
                        f1_r{tp,rep},...
                        w{1,tp,sub,freq}...
                        ] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
                end
            end

            %% Accumulate numeric metrics across repetitions:
            acc_r(:,:,rep) = acc;
            auc_r(:,:,rep) = auc;

            if nreps > 1, mvpalab_pcounter(rep,nreps); end
        end

        %% Average metrics across repetitions:
        acc = mean(acc_r,3);
        auc = mean(auc_r,3);
        for tp = 1 : cfg.tm.ntp
            confmat{sub,tp,freq}   = mvpalab_meanreps(cm_r(tp,:));
            precision{sub,tp,freq} = mvpalab_meanreps(pr_r(tp,:));
            recall{sub,tp,freq}    = mvpalab_meanreps(re_r(tp,:));
            f1score{sub,tp,freq}   = mvpalab_meanreps(f1_r(tp,:));
        end

        % Reestructure result:
        if cfg.classmodel.tempgen
            res.acc(:,:,sub,freq) = acc;
            if cfg.classmodel.auc
                res.auc(:,:,sub,freq) = auc;
            end
        else
            res.acc(:,:,sub,freq) = acc';
            if cfg.classmodel.auc
                res.auc(:,:,sub,freq) = auc';
            end
        end
    end
    toc;
end

fprintf('\n');

% Return confusion ROC values and AUC if needed:
if cfg.classmodel.roc
    res.roc.x =  mvpalab_reorganize_(cfg,x); 
    res.roc.y =  mvpalab_reorganize_(cfg,y); 
    res.roc.t =  mvpalab_reorganize_(cfg,t);
end

% Return confusion matrix if needed:
if cfg.classmodel.confmat
    res.confmat = mvpalab_reorganize_(cfg,confmat);
end 

% Return precision if needed:
if cfg.classmodel.precision
    res.precision = mvpalab_reorganize(cfg,precision);
end 

% Return recall if needed:
if cfg.classmodel.recall
    res.recall = mvpalab_reorganize(cfg,recall);
end 

% Return f1score if needed:
if cfg.classmodel.f1score
    res.f1score = mvpalab_reorganize(cfg,f1score);
end 

% Return wvector if needed:
if cfg.classmodel.wvector
    res.wvector = mvpalab_reorganize_weights(w);
end

% Save result
if ~cfg.sf.flag, mvpalab_save(cfg,res,'res'); end

end



