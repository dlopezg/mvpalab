function [res,cfg] = mvpalab_mvcc(cfg,fv)

fprintf('<strong> > Computing MVCC analysis: </strong>\n');

nfreq = 1;
if cfg.sf.flag
    folders = dir([cfg.dir.savedir filesep 'fv' filesep 's_*']);
end

%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    tic;
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(length(cfg.subjects)) ' >> ']);
    
    if cfg.sf.flag
        fprintf(' Frequency bands - ');
        folder = [folders(sub).folder filesep folders(sub).name];
        files = dir([folder filesep 'ffv_*.mat']);
        nfreq = length(files);
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
        
        %% Timepoints loop
        if cfg.classmodel.parcomp
            parfor tp = 1 : cfg.tm.ntp
                % Direction A - B:
                [...
                    x_ab{sub,tp,freq},...
                    y_ab{sub,tp,freq},...
                    auc_ab(tp,:),...
                    cr_ab(tp,:), ...
                    cm_ab{sub,tp,freq}...
                    ] = mvpalab_mvcceval(train_X,train_Y,test_X,test_Y,tp,cfg);
                
                % Direction B - A:
                [...
                    x_ba{sub,tp,freq},...
                    y_ba{sub,tp,freq},...
                    auc_ba(tp,:),...
                    cr_ba(tp,:),...
                    cm_ba{sub,tp,freq}...
                    ] = mvpalab_mvcceval(test_X,test_Y,train_X,train_Y,tp,cfg);
            end
        else
            for tp = 1 : cfg.tm.ntp
                % Direction A - B:
                [...
                    x_ab{sub,tp,freq},...
                    y_ab{sub,tp,freq},...
                    auc_ab(tp,:),...
                    cr_ab(tp,:),...
                    cm_ab{sub,tp,freq}...
                    ] = mvpalab_mvcceval(train_X,train_Y,test_X,test_Y,tp,cfg);
                
                % Direction B - A:
                [...
                    x_ba{sub,tp,freq},...
                    y_ba{sub,tp,freq},...
                    auc_ba(tp,:),...
                    cr_ba(tp,:), ...
                    cm_ba{sub,tp,freq}...
                    ] = mvpalab_mvcceval(test_X,test_Y,train_X,train_Y,tp,cfg);
            end
        end
        
        %% Generate data structure for the results:
        
        if cfg.classmodel.tempgen
            res.cr.ab(:,:,sub,freq) = cr_ab;
            res.cr.ba(:,:,sub,freq) = cr_ba;
            res.auc.ab(:,:,sub,freq) = auc_ab;
            res.auc.ba(:,:,sub,freq) = auc_ba;
            
        else
            res.cr.ab(:,:,sub,freq) = cr_ab';
            res.cr.ba(:,:,sub,freq) = cr_ba';
            res.auc.ab(:,:,sub,freq) = auc_ab';
            res.auc.ba(:,:,sub,freq) = auc_ba';
        end
    end
    toc
end

res.x.ab = x_ab;
res.x.ba = x_ba;
res.y.ab = y_ab;
res.y.ba = y_ba;
res.cm.ab = cm_ab;
res.cm.ba = cm_ba; toc

fprintf(' - Done!\n');

end

