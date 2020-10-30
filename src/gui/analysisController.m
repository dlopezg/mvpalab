%% Save cfg state:
save([cfg.study.studyLocation '/cfg.mat'],'cfg');

%% Create result and stats folder
mvpalab_mkdir([cfg.study.studyLocation '/results']);
mvpalab_mkdir([cfg.study.studyLocation '/stats']);

%% Load data, generate conditions and feature extraction:
[cfg,data,fv] = mvpalab_import(cfg);

%% Analysis type:
if strcmp(cfg.study.analysis,'MVPA')
    [result,cfg] = mvpalab_mvpa(cfg,fv);
else
    
end

%% Permutation analysis
if cfg.stats.fag
    [permaps,cfg] = mvpalab_permaps(cfg,fv);
    stats = mvpalab_permtest(cfg,result.cr,permaps);
end