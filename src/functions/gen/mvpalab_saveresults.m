function [] = mvpalab_saveresults(cfg,results)

    mvpalab_mkdir([cfg.study.studyLocation filesep 'results'...
        filesep 'macc']);

    result = results.cr;
    save([cfg.study.studyLocation filesep 'results' filesep ...
        'macc' filesep 'result.mat'],'result','cfg','-v7.3');

    if cfg.classmodel.roc
        mvpalab_mkdir([cfg.study.studyLocation filesep 'results'...
        filesep 'auc']);
        result = results.auc;
        save([cfg.study.studyLocation filesep 'results' filesep ...
            'auc' filesep 'result.mat'],'result','cfg','-v7.3');
    end
end

