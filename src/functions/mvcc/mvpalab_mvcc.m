function [res,cfg] = mvpalab_mvcc(cfg,fv)

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

fprintf('<strong> > Computing MVCC analysis: </strong>\n');

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
            train_X = fv.X.a; test_X = fv.X.b;
            train_Y = fv.Y.a; test_Y = fv.Y.b;
        else
            train_X = fv{sub}.X.a; test_X = fv{sub}.X.b;
            train_Y = fv{sub}.Y.a; test_Y = fv{sub}.Y.b;
        end
        
        %% Update nfold for each subject if LOO is selected:
        if strcmp(cfg.cv.method,'loo')
            cfg.cv.nfolds = cfg.cv.loo(sub);
        end

        %% Electrode selection:
        [train_X,cfg] = mvpalab_chanselection(train_X,cfg);
        [test_X,cfg] = mvpalab_chanselection(test_X,cfg);

        %% Number of cross-validation repetitions (k-fold only):
        nreps = 1;
        if strcmp(cfg.cv.method,'kfold')
            nreps = cfg.cv.nreps;
        end

        %% Repeated cross-validation accumulators:
        acc_ab_r = []; auc_ab_r = []; acc_ba_r = []; auc_ba_r = [];
        cm_ab_r = cell(cfg.tm.ntp,nreps); pr_ab_r = cell(cfg.tm.ntp,nreps);
        re_ab_r = cell(cfg.tm.ntp,nreps); f1_ab_r = cell(cfg.tm.ntp,nreps);
        cm_ba_r = cell(cfg.tm.ntp,nreps); pr_ba_r = cell(cfg.tm.ntp,nreps);
        re_ba_r = cell(cfg.tm.ntp,nreps); f1_ba_r = cell(cfg.tm.ntp,nreps);

        if nreps > 1, fprintf(' Repetition: '); end

        %% Repeated cross-validation loop:
        for rep = 1 : nreps

            %% Timepoints loop
            if cfg.classmodel.parcomp
                parfor tp = 1 : cfg.tm.ntp
                    % Direction A - B:
                    [...
                        x_ab{sub,tp,freq},...
                        y_ab{sub,tp,freq},...
                        t_ab{sub,tp,freq},...
                        auc_ab(tp,:),...
                        acc_ab(tp,:),...
                        cm_ab_r{tp,rep},...
                        pr_ab_r{tp,rep},...
                        re_ab_r{tp,rep},...
                        f1_ab_r{tp,rep},...
                        w_ab{1,tp,sub,freq}...
                        ] = mvpalab_mvcceval(...
                        train_X,train_Y,test_X,test_Y,tp,cfg);

                    % Direction B - A:
                    [...
                        x_ba{sub,tp,freq},...
                        y_ba{sub,tp,freq},...
                        t_ba{sub,tp,freq},...
                        auc_ba(tp,:),...
                        acc_ba(tp,:),...
                        cm_ba_r{tp,rep},...
                        pr_ba_r{tp,rep},...
                        re_ba_r{tp,rep},...
                        f1_ba_r{tp,rep},...
                        w_ba{1,tp,sub,freq}...
                        ] = mvpalab_mvcceval(...
                        test_X,test_Y,train_X,train_Y,tp,cfg);
                end
            else
                for tp = 1 : cfg.tm.ntp
                    % Direction A - B:
                    [...
                        x_ab{sub,tp,freq},...
                        y_ab{sub,tp,freq},...
                        t_ab{sub,tp,freq},...
                        auc_ab(tp,:),...
                        acc_ab(tp,:),...
                        cm_ab_r{tp,rep},...
                        pr_ab_r{tp,rep},...
                        re_ab_r{tp,rep},...
                        f1_ab_r{tp,rep},...
                        w_ab{1,tp,sub,freq}...
                        ] = mvpalab_mvcceval(...
                        train_X,train_Y,test_X,test_Y,tp,cfg);

                    % Direction B - A:
                    [...
                        x_ba{sub,tp,freq},...
                        y_ba{sub,tp,freq},...
                        t_ba{sub,tp,freq},...
                        auc_ba(tp,:),...
                        acc_ba(tp,:),...
                        cm_ba_r{tp,rep},...
                        pr_ba_r{tp,rep},...
                        re_ba_r{tp,rep},...
                        f1_ba_r{tp,rep},...
                        w_ba{1,tp,sub,freq}...
                        ] = mvpalab_mvcceval(...
                        test_X,test_Y,train_X,train_Y,tp,cfg);
                end
            end

            %% Accumulate numeric metrics across repetitions:
            acc_ab_r(:,:,rep) = acc_ab; auc_ab_r(:,:,rep) = auc_ab;
            acc_ba_r(:,:,rep) = acc_ba; auc_ba_r(:,:,rep) = auc_ba;

            if nreps > 1, mvpalab_pcounter(rep,nreps); end
        end

        %% Average metrics across repetitions:
        acc_ab = mean(acc_ab_r,3); auc_ab = mean(auc_ab_r,3);
        acc_ba = mean(acc_ba_r,3); auc_ba = mean(auc_ba_r,3);
        for tp = 1 : cfg.tm.ntp
            confmat_ab{sub,tp,freq}   = mvpalab_meanreps(cm_ab_r(tp,:));
            precision_ab{sub,tp,freq} = mvpalab_meanreps(pr_ab_r(tp,:));
            recall_ab{sub,tp,freq}    = mvpalab_meanreps(re_ab_r(tp,:));
            f1score_ab{sub,tp,freq}   = mvpalab_meanreps(f1_ab_r(tp,:));
            confmat_ba{sub,tp,freq}   = mvpalab_meanreps(cm_ba_r(tp,:));
            precision_ba{sub,tp,freq} = mvpalab_meanreps(pr_ba_r(tp,:));
            recall_ba{sub,tp,freq}    = mvpalab_meanreps(re_ba_r(tp,:));
            f1score_ba{sub,tp,freq}   = mvpalab_meanreps(f1_ba_r(tp,:));
        end

        %% Generate data structure for the results:
        if cfg.classmodel.tempgen
            res.acc.ab(:,:,sub,freq) = acc_ab;
            res.acc.ba(:,:,sub,freq) = acc_ba;
            res.acc.mean(:,:,sub,freq) = mean(cat(3,acc_ab,acc_ba),3);
            if cfg.classmodel.auc
                res.auc.ab(:,:,sub,freq) = auc_ab;
                res.auc.ba(:,:,sub,freq) = auc_ba;
                res.auc.mean(:,:,sub,freq) = mean(cat(3,auc_ab,auc_ba),3);
            end
        else
            res.acc.ab(:,:,sub,freq) = acc_ab';
            res.acc.ba(:,:,sub,freq) = acc_ba';
            res.acc.mean(:,:,sub,freq) = mean([acc_ab,acc_ba],2)';
            if cfg.classmodel.auc
                res.auc.ab(:,:,sub,freq) = auc_ab';
                res.auc.ba(:,:,sub,freq) = auc_ba';
                res.auc.mean(:,:,sub,freq) = mean([auc_ab,auc_ba],2)';
            end
        end
    end
    toc
end

fprintf('\n');

% Return confusion ROC values and AUC if needed:
if cfg.classmodel.roc
    res.roc.x =  mvpalab_reorganize_(cfg,x_ab,x_ba); 
    res.roc.y =  mvpalab_reorganize_(cfg,y_ab,y_ba); 
    res.roc.t =  mvpalab_reorganize_(cfg,t_ab,t_ba);
end

% Return confusion matrix if needed:
if cfg.classmodel.confmat
    res.confmat = mvpalab_reorganize_(cfg,confmat_ab,confmat_ba);
end 

% Return precision if needed:
if cfg.classmodel.precision
    res.precision = mvpalab_reorganize(cfg,precision_ab,precision_ba);
end 

% Return recall if needed:
if cfg.classmodel.recall
    res.recall = mvpalab_reorganize(cfg,recall_ab,recall_ba);
end 

% Return f1score if needed:
if cfg.classmodel.f1score
    res.f1score = mvpalab_reorganize(cfg,f1score_ab,f1score_ba);
end 

% Return wvector if needed:
if cfg.classmodel.wvector
    res.wvector.ab = mvpalab_reorganize_weights(w_ab);
    res.wvector.ba = mvpalab_reorganize_weights(w_ba);
end

if ~cfg.sf.flag, mvpalab_save(cfg,res,'res'); end

end

