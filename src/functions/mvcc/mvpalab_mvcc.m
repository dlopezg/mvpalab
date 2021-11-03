function [res,cfg] = mvpalab_mvcc(cfg,fv)

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
                    confmat_ab{sub,tp,freq},...
                    precision_ab{sub,tp,freq},...
                    recall_ab{sub,tp,freq},...
                    f1score_ab{sub,tp,freq},...
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
                    confmat_ba{sub,tp,freq},...
                    precision_ba{sub,tp,freq},...
                    recall_ba{sub,tp,freq},...
                    f1score_ba{sub,tp,freq},...
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
                    confmat_ab{sub,tp,freq},...
                    precision_ab{sub,tp,freq},...
                    recall_ab{sub,tp,freq},...
                    f1score_ab{sub,tp,freq},...
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
                    confmat_ba{sub,tp,freq},...
                    precision_ba{sub,tp,freq},...
                    recall_ba{sub,tp,freq},...
                    f1score_ba{sub,tp,freq},...
                    w_ba{1,tp,sub,freq}...
                    ] = mvpalab_mvcceval(...
                    test_X,test_Y,train_X,train_Y,tp,cfg);
            end
        end
        
        %% Generate data structure for the results:
        
        if cfg.classmodel.tempgen
            res.acc.ab(:,:,sub,freq) = acc_ab;
            res.acc.ba(:,:,sub,freq) = acc_ba;
            if cfg.classmodel.auc
                res.auc.ab(:,:,sub,freq) = auc_ab;
                res.auc.ba(:,:,sub,freq) = auc_ba;
            end
        else
            res.acc.ab(:,:,sub,freq) = acc_ab';
            res.acc.ba(:,:,sub,freq) = acc_ba';
            if cfg.classmodel.auc
                res.auc.ab(:,:,sub,freq) = auc_ab';
                res.auc.ba(:,:,sub,freq) = auc_ba';
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

if ~cfg.sf.flag
    mvpalab_saveresults(cfg,res);
end

end

