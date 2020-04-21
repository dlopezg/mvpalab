function [permaps,cfg] = mvpalab_permaps(cfg,fv )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing permutated maps: </strong>\n');

if cfg.sf.flag
    folders = dir([cfg.dir.savedir filesep 'fv' filesep 's_*']);
end

%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    if cfg.sf.flag
        folder = [folders(sub).folder filesep folders(sub).name];
        files = dir([folder filesep 'ffv_*.mat']);
    end
    
    for freq = 1 : length(files)
        tic;
        fprintf(['   - Subject: ' int2str(sub) '/' int2str(length(cfg.subjects)) ' >> ']);
        fprintf([' Bands - ' int2str(freq) '/' int2str(length(files)) ' >> ']);
        fprintf('- Permutation: ');
        %% Load data if needed:
        if cfg.sf.flag
            file = [files(freq).folder filesep files(freq).name];
            load(file);
            X = fv.X.a; Y = fv.Y.a;
        else
            X = fv.X{sub}.a; Y = fv.Y{sub}.a;
        end
        
        %% Stratified partition for cross validation:
        strpar = cvpartition(Y,'KFold',cfg.cv.nfolds);
        cfg.classmodel.permlab = true;
        for per = 1 : cfg.stats.nper
            %% Stratified partition for cross validation:
            strpar = cvpartition(Y,'KFold',cfg.cv.nfolds);
            
            %% Timepoints loop
            if cfg.classmodel.parcomp
                parfor tp = 1 : cfg.tm.ntp
                    [~,~,~,auc(tp,:),cr(tp,:),~] = mvpalab_mvpaeval(...
                        X,Y,tp,cfg,strpar);
                end
                mvpalab_pcounter(per,cfg.stats.nper);
            else
                for tp = 1 : cfg.analysis.ntp
                    [~,~,~,auc(tp,:),cr(tp,:),~] = mvpalab_mvpaeval(...
                        X,Y,tp,cfg,strpar);
                end
                
                mvpalab_pcounter(per,cfg.stats.nper);
            end
            
            if cfg.classmodel.tempgen
                if cfg.classmodel.roc
                    permaps(:,:,sub,per,freq) = auc;
                else
                    permaps(:,:,sub,per,freq) = cr;
                end
            else
                if cfg.classmodel.roc
                    permaps(:,:,sub,per,freq) = auc';
                else
                    permaps(:,:,sub,per,freq) = cr';
                end
            end
        end
        fprintf(' >> ');
        toc;
    end
end
cfg.classmodel.permlab = false;
fprintf(' - Done!\n');
end



