function [permaps,cfg] = mvpalab_permaps(cfg,fv )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing permutated maps: </strong>\n');

nSubjects = length(cfg.study.dataFiles{1,1});
nfreq = 1;
if cfg.sf.flag
    folders = dir([cfg.dir.savedir filesep 'fv' filesep 's_*']);
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
%         fprintf([' Bands - ' int2str(freq) '/' int2str(length(files)) ' >> ']);
        fprintf('- Permutation: ');
        %% Load data if needed:
        if cfg.sf.flag
            file = [files(freq).folder filesep files(freq).name];
            load(file);
            X = fv.X.a; Y = fv.Y.a;
        else
            X = fv{sub}.X.a; Y = fv{sub}.Y.a;
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
                permaps.cr(:,:,sub,per,freq) = cr;
                if cfg.classmodel.roc
                    permaps.auc(:,:,sub,per,freq) = auc;
                end
            else
                permaps.cr(:,:,sub,per,freq) = cr';
                if cfg.classmodel.roc
                    permaps.auc(:,:,sub,per,freq) = auc';
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



