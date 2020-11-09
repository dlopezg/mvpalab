%% Save cfg state:
save([cfg.study.studyLocation '/cfg.mat'],'cfg');

%% Create result and stats folder
mvpalab_mkdir([cfg.study.studyLocation '/results']);
mvpalab_mkdir([cfg.study.studyLocation '/stats']);

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% If analysis type is MVPA:
if strcmp(cfg.study.analysis,'MVPA')
    [result,cfg] = mvpalab_mvpa(cfg,fv);
    save([cfg.study.studyLocation filesep 'results' filesep ...
        'result.mat'],'result','-v7.3');
    save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');
    
    %% If permutation analysis is enabled
    if cfg.stats.flag
        [permaps,cfg] = mvpalab_permaps(cfg,fv);
        
        if strcmp(cfg.stats.pmetric,'cr')
            pmaps = permaps.cr;
            perfo = result.cr;
            mvpalab_mkdir([cfg.study.studyLocation filesep 'stats'...
                filesep 'cr']);
        elseif strcmp(cfg.stats.pmetric,'auc')
            pmaps = permaps.auc;
            perfo = result.auc;
            mvpalab_mkdir([cfg.study.studyLocation filesep 'stats'...
                filesep 'auc']);
        end
        stats = mvpalab_permtest(cfg,perfo,pmaps);
        
        save([cfg.study.studyLocation filesep...
            'stats' filesep cfg.stats.pmetric filesep ...
            'stats.mat'],'stats','-v7.3');
        save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');
        
        if cfg.stats.savepmaps
            save([cfg.study.studyLocation filesep 'stats' filesep...
                'permaps.mat'],'permaps','-v7.3');
        end
    end
end

%% If analysis type is MVPA:
if strcmp(cfg.study.analysis,'MVCC')
    [result,cfg] = mvpalab_mvcc(cfg,fv);
    save([cfg.study.studyLocation filesep 'results' filesep ...
        'result.mat'],'result','-v7.3');
    save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');
    
    %% If permutation analysis is enabled
    if cfg.stats.flag
        [permaps,cfg] = mvpalab_cpermaps(cfg,fv);
        
        if strcmp(cfg.stats.pmetric,'cr')
            pmaps = permaps.cr;
            perfo = result.cr;
            mvpalab_mkdir([cfg.study.studyLocation filesep 'stats'...
                filesep 'cr']);
        elseif strcmp(cfg.stats.pmetric,'auc')
            pmaps = permaps.auc;
            perfo = result.auc;
            mvpalab_mkdir([cfg.study.studyLocation filesep 'stats'...
                filesep 'auc']);
        end
        
        if strcmp(cfg.study.mvccDirection,'both')
            stats.ab = mvpalab_permtest(cfg,perfo.ab,pmaps.ab);
            stats.ba = mvpalab_permtest(cfg,perfo.ba,pmaps.ba);
        elseif strcmp(cfg.study.mvccDirection,'AB')
            stats.ab = mvpalab_permtest(cfg,perfo.ab,pmaps.ab);
        elseif strcmp(cfg.study.mvccDirection,'BA')
            stats.ba = mvpalab_permtest(cfg,perfo.ba,pmaps.ba);
        end
        
        save([cfg.study.studyLocation filesep...
            'stats' filesep cfg.stats.pmetric filesep ...
            'stats.mat'],'stats','-v7.3');
        save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');
        
        if cfg.stats.savepmaps
            save([cfg.study.studyLocation filesep 'stats' filesep...
                'permaps.mat'],'permaps','-v7.3');
        end
    end
end


