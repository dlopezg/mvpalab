%% Save cfg state:
save([cfg.study.studyLocation '/cfg.mat'],'cfg');

%% Create result and stats folder
mvpalab_mkdir([cfg.study.studyLocation '/results']);
mvpalab_mkdir([cfg.study.studyLocation '/sf']);
mvpalab_mkdir([cfg.study.studyLocation '/stats']);

%% Load data, generate conditions and feature extraction:
cfg = mvpalab_import(cfg);

%% Sliding filter analysis for each frequency band - MVCC:
cfg.sf.flag = true;
[accmap,cfg] = mvpalab_mvcc(cfg);

%% Save accmaps and cfg structure:
save([cfg.study.studyLocation filesep 'results' filesep ...
    'accmap.mat'],'accmap','-v7.3');
save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');

%% Generate permuted maps for each frequency band:
if cfg.stats.flag
    [permaps,cfg] = mvpalab_cpermaps(cfg);
    if cfg.stats.savepmaps
        save([cfg.study.studyLocation filesep 'stats' filesep...
            'permaps.mat'],'permaps','-v7.3');
    end
end

%% Load data, generate conditions and feature extraction:
cfg.sf.flag = false;
[cfg,data,fv] = mvpalab_import(cfg);

%% MVCC analysis:
[acc,cfg] = mvpalab_mvcc(cfg,fv);
cfg.classmodel.permlab = true;
[peracc,cfg] = mvpalab_mvcc(cfg,fv);

%% Sliding filter analysis - Generate diffMaps:

[diffMap.ab,perdiffMap.ab,cfg] = mvpalab_gendiffmap(...
    cfg,acc.cr.ab,accmap.cr.ab,peracc.cr.ab,permaps.cr.ab);
[diffMap.ba,perdiffMap.ba,cfg] = mvpalab_gendiffmap(...
    cfg,acc.cr.ba,accmap.cr.ba,peracc.cr.ba,permaps.cr.ba);

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



save([cfg.study.studyLocation filesep...
    'stats' filesep cfg.stats.pmetric filesep ...
    'stats.mat'],'stats','-v7.3');
save([cfg.study.studyLocation filesep 'cfg.mat'],'cfg','-v7.3');

