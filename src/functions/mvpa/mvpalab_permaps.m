function [permaps,cfg] = mvpalab_permaps(cfg,fv )
%% MVPALAB_PERMAPS 
% Summary of this function goes here

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

%   Detailed explanation goes here
fprintf('<strong> > Computing permuted maps: </strong>\n');

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
        
        %% Number of cross-validation repetitions (k-fold only):
        cfg.classmodel.permlab = true;
        nreps = 1;
        if strcmp(cfg.cv.method,'kfold')
            nreps = cfg.cv.nreps;
        end
        wper = numel(num2str(cfg.stats.nper));
        wrep = numel(num2str(nreps));
        msglen = 0;

        for per = 1 : cfg.stats.nper

            %% Repeated cross-validation accumulators:
            acc_r = []; auc_r = [];
            pr_r = cell(cfg.tm.ntp,nreps);
            re_r = cell(cfg.tm.ntp,nreps);
            f1_r = cell(cfg.tm.ntp,nreps);

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
                        [~,~,~,...
                        auc(tp,:),...
                        acc(tp,:),...
                        ~,...
                        pr_r{tp,rep},...
                        re_r{tp,rep},...
                        f1_r{tp,rep},...
                        ~] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
                    end
                else
                    for tp = 1 : cfg.tm.ntp
                        [~,~,~,...
                        auc(tp,:),...
                        acc(tp,:),...
                        ~,...
                        pr_r{tp,rep},...
                        re_r{tp,rep},...
                        f1_r{tp,rep},...
                        ~] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
                    end
                end

                %% Accumulate numeric metrics across repetitions:
                acc_r(:,:,rep) = acc;
                auc_r(:,:,rep) = auc;

                %% Live progress (permutation + repetition):
                if nreps > 1
                    msg = sprintf('%*d/%d - Repetition: %*d/%d',...
                        wper,per,cfg.stats.nper,wrep,rep,nreps);
                    fprintf('%s%s',repmat(char(8),1,msglen),msg);
                    msglen = numel(msg);
                end
            end

            %% Average metrics across repetitions:
            acc = mean(acc_r,3);
            auc = mean(auc_r,3);
            for tp = 1 : cfg.tm.ntp
                precision{sub,tp,freq,per} = mvpalab_meanreps(pr_r(tp,:));
                recall{sub,tp,freq,per}    = mvpalab_meanreps(re_r(tp,:));
                f1score{sub,tp,freq,per}   = mvpalab_meanreps(f1_r(tp,:));
            end

            if nreps == 1, mvpalab_pcounter(per,cfg.stats.nper); end

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

fprintf('\n');

% Return precision if needed:
if cfg.classmodel.precision
    permaps.precision = mvpalab_reorganize(cfg,precision);
end 

% Return recall if needed:
if cfg.classmodel.recall
    permaps.recall = mvpalab_reorganize(cfg,recall);
end 

% Return f1score if needed:
if cfg.classmodel.f1score
    permaps.f1score = mvpalab_reorganize(cfg,f1score);
end 

cfg.classmodel.permlab = false;

if ~cfg.sf.flag, mvpalab_save(cfg,permaps,'permaps'); end

end



