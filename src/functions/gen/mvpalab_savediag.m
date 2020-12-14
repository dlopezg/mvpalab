function [] = mvpalab_savediag(cfg,results,permaps,statistics)
cfg.classmodel.tempgen = 0;
result = results.cr;
stats = statistics.cr;
macc_dir = [cfg.study.studyLocation filesep ...
    'results' filesep 'macc' filesep 'diag'];
mvpalab_mkdir(macc_dir);
save([macc_dir filesep 'result.mat'],'result','cfg','-v7.3');

if nargin > 2
    save([macc_dir filesep 'stats.mat'],'stats','-v7.3');
    save([macc_dir filesep 'permaps.mat'],'permaps','-v7.3');
end

if cfg.classmodel.roc
    result = results.auc;
    stats = statistics.auc;
    auc_dir = [cfg.study.studyLocation filesep ...
        'results' filesep 'auc' filesep 'diag'];
    mvpalab_mkdir(auc_dir);
    save([auc_dir filesep 'result.mat'],'result','cfg','-v7.3');
    
    if nargin > 2
        save([auc_dir filesep 'stats.mat'],'stats','-v7.3');
        save([auc_dir filesep 'permaps.mat'],'permaps','-v7.3');
    end
end
cfg.classmodel.tempgen = 1;
end

