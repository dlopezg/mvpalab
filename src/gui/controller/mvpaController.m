%% Save cfg state:
save([cfg.study.studyLocation '/cfg.mat'],'cfg');

%% Create result and stats folder
mvpalab_mkdir([cfg.study.studyLocation '/results']);
mvpalab_mkdir([cfg.study.studyLocation '/stats']);

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Compute MVPA analysis:
[result,cfg] = mvpalab_mvpa(cfg,fv);

%% Save result and cfg structure:
save([cfg.study.studyLocation filesep 'results' filesep ...
    'result.mat'],'result','-v7.3');
save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');
    
%% If permutation analysis is enabled
if cfg.stats.flag
    %% Generate permuted maps:
    [permaps,cfg] = mvpalab_permaps(cfg,fv);
    
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
    
    %% Compute the permutation based analysis:
    stats = mvpalab_permtest(cfg,perfo,pmaps);
    
    %% Save the result and de cfg structure:
    save([cfg.study.studyLocation filesep...
        'stats' filesep cfg.stats.pmetric filesep ...
        'stats.mat'],'stats','-v7.3');
    save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');
    
end