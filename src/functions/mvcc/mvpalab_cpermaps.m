function [permaps,cfg] = mvpalab_cpermaps(cfg,fv)
%PERMUTATION_MAPS This function generates permutation maps at a subject
%level for future statistical analyses.
fprintf('<strong> > Computing permutated maps (MVCC): </strong>\n');

nSubjects = length(cfg.study.dataFiles{1,1});
nfreq = 1;
if cfg.sf.flag
    folders = dir([cfg.sf.filesLocation filesep 'fv' filesep 's_*']);
end

%% Subjects loop:
for sub = 1 : nSubjects 
    
    if cfg.sf.flag
        folder = [folders(sub).folder filesep folders(sub).name];
        files = dir([folder filesep 'ffv_*.mat']);
        nfreq = length(files);
    end
    
    for freq = 1 : nfreq
        tic;
        fprintf(['   - Subject: ' int2str(sub) '/' int2str(nSubjects) ' >> ']);
        % fprintf([' Bands - ' int2str(freq) '/' int2str(length(files)) ' >> ']);
        fprintf('- Permutation: ');
        %% Load data if needed:
        if cfg.sf.flag
            file = [files(freq).folder filesep files(freq).name];
            load(file);
            train_X = fv.X.a; test_X = fv.X.b;
            train_Y = fv.Y.a; test_Y = fv.Y.b;
        else
            train_X = fv{sub}.X.a; test_X = fv{sub}.X.b;
            train_Y = fv{sub}.Y.a; test_Y = fv{sub}.Y.b;
        end
        
        %% Generate permuted labels
        for per = 1 : cfg.stats.nper
            cfg.classmodel.permlab = true;
            mvpalab_pcounter(per,cfg.stats.nper);
            if cfg.classmodel.parcomp
                %% Timepoints loop
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
            
            if cfg.classmodel.tempgen
                permaps.cr.ab(:,:,sub,per,freq) = cr_ab;
                permaps.cr.ba(:,:,sub,per,freq) = cr_ba;
                permaps.auc.ab(:,:,sub,per,freq) = auc_ab;
                permaps.auc.ba(:,:,sub,per,freq) = auc_ba;
            else
                permaps.cr.ab(:,:,sub,per,freq) = cr_ab';
                permaps.cr.ba(:,:,sub,per,freq) = cr_ba';
                permaps.auc.ab(:,:,sub,per,freq) = auc_ab';
                permaps.auc.ba(:,:,sub,per,freq) = auc_ba';
            end
        end
        fprintf(' >> ');
        toc;
    end
end
cfg.classmodel.permlab = false;
fprintf(' - Done!\n');
end

