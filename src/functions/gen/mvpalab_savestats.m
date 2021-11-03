function [] = mvpalab_savestats(cfg,statistics)

fprintf('<strong> > Saving stats: </strong>');

fields = fieldnames(statistics);
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
    
    % Extract stats:
    stats = statistics.(fields{i});
    
    % Save stats file:
    if find(strcmp(additionalmetrics,fields{i}))
        temp = stats;
        fields_ = fieldnames(temp);
        for j = 1 : numel(fields_)
            subfolder = [savefolder fields{i} filesep fields_{j} filesep];
            mvpalab_mkdir(subfolder);
            stats = stats.(fields_{j});
            save([subfolder 'stats.mat'], 'stats','cfg','-v7.3');
            stats = temp;
        end
    else
        save([savefolder fields{i} filesep 'stats.mat'],'stats','cfg','-v7.3');
    end
end

fprintf(' > Done! ');
fprintf('\n\n');

end

