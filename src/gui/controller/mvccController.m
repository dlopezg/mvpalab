%% Save cfg state:
save([cfg.study.studyLocation '/cfg.mat'],'cfg');

%% Create result and stats folder
mvpalab_mkdir([cfg.study.studyLocation '/results']);
mvpalab_mkdir([cfg.study.studyLocation '/stats']);

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVCC analysis:
[result,cfg] = mvpalab_mvcc(cfg,fv);

%% Save result and cfg structure:
save([cfg.study.studyLocation filesep 'results' filesep ...
    'result.mat'],'result','-v7.3');
save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');

%% If permutation analysis is enabled
if cfg.stats.flag
    %% Generate permuted maps:
    [permaps,cfg] = mvpalab_cpermaps(cfg,fv);
    
    %% Save permuted maps if needed:
    if cfg.stats.savepmaps
        save([cfg.study.studyLocation filesep 'stats' filesep...
            'permaps.mat'],'permaps','-v7.3');
    end
    
    %% Select the correct metric for the permutation analysis (CR/AUC):
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
    
    %% Cross-classification direction:
    if strcmp(cfg.study.mvccDirection,'both')
        stats.ab = mvpalab_permtest(cfg,perfo.ab,pmaps.ab);
        stats.ba = mvpalab_permtest(cfg,perfo.ba,pmaps.ba);
    elseif strcmp(cfg.study.mvccDirection,'AB')
        stats.ab = mvpalab_permtest(cfg,perfo.ab,pmaps.ab);
    elseif strcmp(cfg.study.mvccDirection,'BA')
        stats.ba = mvpalab_permtest(cfg,perfo.ba,pmaps.ba);
    end
    
    %% Save the result and de cfg structure:
    save([cfg.study.studyLocation filesep...
        'stats' filesep cfg.stats.pmetric filesep ...
        'stats.mat'],'stats','-v7.3');
    save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');
    
end