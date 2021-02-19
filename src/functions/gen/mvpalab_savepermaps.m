function [] = mvpalab_savepermaps(cfg,pmaps)

fields = fieldnames(pmaps);
additionalmetrics = {'precision', 'recall', 'f1score'};

if cfg.classmodel.tempgen
    folder = 'temporal_generalization';
else
    folder = 'time_resolved';
end

savefolder = [cfg.location filesep 'results' filesep folder filesep];

for i = 1 : numel(fields)
    % Create folder:
    mvpalab_mkdir([savefolder fields{i}]);
    
    % Extract result:
    permaps = pmaps.(fields{i});
    
    % Save result file:
    if find(strcmp(additionalmetrics,fields{i}))
        temp = permaps;
        fields_ = fieldnames(temp);
        for j = 1 : numel(fields_)
            subfolder = [savefolder fields{i} filesep fields_{j} filesep];
            mvpalab_mkdir(subfolder);
            permaps = permaps.(fields_{j});
            save([subfolder 'permaps.mat'], 'permaps','cfg','-v7.3');
            permaps = temp;
        end
    else
        save([savefolder fields{i} filesep 'permaps.mat'],'permaps','cfg','-v7.3');
    end
end
end

