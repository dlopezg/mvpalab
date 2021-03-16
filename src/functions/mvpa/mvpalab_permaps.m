function [permaps,cfg] = mvpalab_permaps(cfg,fv )
%CORRECT_RATE Summary of this function goes here
%   Detailed explanation goes here
fprintf('<strong> > Computing permutated maps: </strong>\n');

% Enable statistics:
cfg.stats.flag = 1;

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
        nfreq = length(cfg.sf.freqvec);
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
            if strcmp(cfg.cv.method,'loo')
                cfg.cv.nfolds = cfg.cv.loo(sub);
            end
            strpar = cvpartition(Y,'KFold',cfg.cv.nfolds);
            
            %% Timepoints loop
            if cfg.classmodel.parcomp
                parfor tp = 1 : cfg.tm.ntp
                    [~,~,~,...
                    auc(tp,:),...
                    acc(tp,:),...
                    ~,...
                    precision{sub,tp,freq,per},...
                    recall{sub,tp,freq,per},...
                    f1score{sub,tp,freq,per},...
                    ~] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
                end
                mvpalab_pcounter(per,cfg.stats.nper);
            else
                for tp = 1 : cfg.tm.ntp
                    [~,~,~,...
                    auc(tp,:),...
                    acc(tp,:),...
                    ~,...
                    precision{sub,tp,freq,per},...
                    recall{sub,tp,freq,per},...
                    f1score{sub,tp,freq,per},...
                    ~] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
                end
                
                mvpalab_pcounter(per,cfg.stats.nper);
            end
            
            if cfg.classmodel.tempgen
                permaps.acc(:,:,sub,per,freq) = acc;
                if cfg.classmodel.auc
                    permaps.auc(:,:,sub,per,freq) = auc;
                end
            else
                permaps.acc(:,:,sub,per,freq) = acc';
                if cfg.classmodel.auc
                    permaps.auc(:,:,sub,per,freq) = auc';
                end
            end
        end
        fprintf(' >> ');
        toc;
    end
end

% Return precision if needed:
if cfg.classmodel.precision
    permaps.precision = mvpalab_reorganize(cfg,precision);
end 

% Return recall if needed:
if cfg.classmodel.precision
    permaps.recall = mvpalab_reorganize(cfg,recall);
end 

% Return f1score if needed:
if cfg.classmodel.precision
    permaps.f1score = mvpalab_reorganize(cfg,f1score);
end 

cfg.classmodel.permlab = false;

if ~cfg.sf.flag
    mvpalab_savepermaps(cfg,permaps);
end


fprintf(' - Done!\n');
end



