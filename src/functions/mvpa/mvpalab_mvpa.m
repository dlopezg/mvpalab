function [res,cfg] = mvpalab_mvpa(cfg,fv)

fprintf('<strong> > Computing MVPA analysis: </strong>\n');

%% Initialization
nSubjects = length(cfg.study.dataFiles{1,1});

nfreq = 1;
if cfg.sf.flag
    folders = dir([cfg.dir.savedir filesep 'fv' filesep 's_*']);
end

%% Subjects loop:
for sub = 1 : nSubjects
    tic;
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nSubjects) ' >> ']);
    
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
            X = fv.X.a; Y = fv.Y.a;
        else
            X = fv{sub}.X.a; Y = fv{sub}.Y.a;
        end
        
        %% Stratified partition for cross validation:
        strpar = cvpartition(Y,'KFold',cfg.cv.nfolds);
        
        %% Timepoints loop
        if cfg.classmodel.parcomp
            parfor tp = 1 : cfg.tm.ntp
                [...
                    x{sub,tp,freq},...
                    y{sub,tp,freq},...
                    t{sub,tp,freq},...
                    auc(tp,:),...
                    cr(tp,:),...
                    cm{sub,tp,freq},...
                    w{sub,tp,freq}...
                    ] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
            end
        else
            for tp = 1 : cfg.tm.ntp
                [...
                    x{sub,tp,freq},...
                    y{sub,tp,freq},...
                    t{sub,tp,freq},...
                    auc(tp,:),...
                    cr(tp,:),...
                    cm{sub,tp,freq},...
                    w{sub,tp,freq}...
                    ] = mvpalab_mvpaeval(X,Y,tp,cfg,strpar);
            end
        end
        
        if cfg.classmodel.tempgen
            res_auc(:,:,sub,freq) = auc;
            res_cr(:,:,sub,freq) = cr;
        else
            res_auc(:,:,sub,freq) = auc';
            res_cr(:,:,sub,freq) = cr';
        end
    end
    toc;
end
res.x = x;
res.y = y;
res.t = t;
res.auc = res_auc;
res.cr = res_cr;
res.cm = cm;
res.w = w;

fprintf(' - Done!\n');
end



