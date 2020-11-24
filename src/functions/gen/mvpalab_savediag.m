function [] = mvpalab_savediag(cfg,results,permaps,stats)

result = results.cr;
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
    auc_dir = [cfg.study.studyLocation filesep ...
        'results' filesep 'auc' filesep 'diag'];
    mvpalab_mkdir(auc_dir);
    save([auc_dir filesep 'result.mat'],'result','cfg','-v7.3');
    
    if nargin > 2
        save([auc_dir filesep 'stats.mat'],'stats','-v7.3');
        save([auc_dir filesep 'permaps.mat'],'permaps','-v7.3');
    end
end
end

