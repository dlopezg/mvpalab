function [] = mvpalab_saveresults(cfg,results)

fprintf('\n');
fprintf('<strong> > Saving the results: </strong>');

fields = fieldnames(results);
additionalmetrics = {'precision','recall','f1score'};
metrics = {'acc','auc','roc','confmat','precision','recall','f1score','wvector'};

if cfg.classmodel.tempgen
    folder = 'temporal_generalization';
else
    folder = 'time_resolved';
end

savefolder = [cfg.location filesep 'results' filesep folder filesep];

for i = 1 : numel(fields)
    if find(strcmp(metrics,fields{i}))
        % Create folder:
        mvpalab_mkdir([savefolder fields{i}]);
        
        % Extract result:
        result = results.(fields{i});
        
        % Save result file:
        if find(strcmp(additionalmetrics,fields{i}))
            temp = result;
            fields_ = fieldnames(temp);
            for j = 1 : numel(fields_)
                subfolder = [savefolder fields{i} filesep fields_{j} filesep];
                mvpalab_mkdir(subfolder);
                result = result.(fields_{j});
                save([subfolder 'result.mat'], 'result','cfg','-v7.3');
                result = temp;
            end
        else
            save([savefolder fields{i} filesep 'result.mat'],'result','cfg','-v7.3');
        end
    end
end

fprintf(' > Done! ');

end

