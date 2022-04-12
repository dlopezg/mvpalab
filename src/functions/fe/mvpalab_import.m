function [cfg, data, fv] = mvpalab_import(cfg)
%GENERATE_CONDITIONS This function reads the subject's data and generate
%the required structure for the feature extraction.

%% Initialization
nSubjects = length(cfg.study.dataFiles{1,1});
nCtxt = 1;

if ~cfg.sf.flag
    cfg.sf.nfreq = 1;
end

% Check cfg integrity and backwards compatibility:
cfg = mvpalab_checkcfg(cfg);

% Prepare frequency contribution analysis:
if cfg.sf.flag
    % Check EEGlab:
    mvpalab_checkeeglab();
    % Prepare analysis:
    cfg = mvpalab_preparesf(cfg);
end

% Prepare MVCC analysis if needed:
if ~isempty(cfg.study.dataFiles{2,1}) && ~isempty(cfg.study.dataFiles{2,2})
    cfg.analysis = 'MVCC';
    nCtxt = 2;
end

%% Subjects loop:
for sub = 1 : nSubjects
    fprintf('\n');
    fprintf('<strong> > Importing subject data </strong> - Subject: ');
    fprintf([int2str(sub) '/' int2str(length(cfg.study.dataFiles{1,1}))]);
    fprintf('\n');
    
    for freq = 1 : cfg.sf.nfreq
        
        if cfg.sf.flag
            fprintf('  <strong> > Filtering data: </strong>');
            fprintf([int2str(freq) '/' int2str(cfg.sf.nfreq) '\n\n']);
        end
        
        for ctxt = 1 : nCtxt
            for class = 1 : length(cfg.study.dataFiles)
                
                % Load subject data:
                try
                    if strcmp(cfg.study.dataFiles{ctxt,class}{sub}(end-3:end),'.mat')
                        temp = load([cfg.study.dataPaths{ctxt,class} ...
                            cfg.study.dataFiles{ctxt,class}{sub}]);
                    elseif strcmp(cfg.study.dataFiles{ctxt,class}{sub}(end-3:end),'.set')
                        mvpalab_checkeeglab();
                        temp.data = pop_loadset(cfg.study.dataFiles{ctxt,class}{sub},cfg.study.dataPaths{ctxt,class});
                    end
                    
                catch
                    error(['Data files not found. '...
                        'Directory: ' cfg.study.dataPaths{ctxt,class}]);
                end
                
                % Read and prepare input data for MVPAlab:
                [cfg,EEG] = mvpalab_dataformat(cfg,temp);
                
                % Sliding filter analysis if needed.
                if cfg.sf.flag
                    EEG.data = mvpalab_filterdata(EEG,freq,cfg);
                end
                
                % Remove spaces to avoid errors:
                id = cfg.study.conditionIdentifier{ctxt,class};
                id = id(~isspace(id));
                
                classes.(id) = EEG.data;
            end
            data{sub,ctxt} = classes;
            clear classes;
        end
        
        if cfg.sf.flag
            [fv{sub},cfg] = mvpalab_fext(cfg,data(sub,:),sub);
            cfg.tm.times = EEG.times;
            cfg.tm.rtimes = EEG.times;
            cfg = mvpalab_timing(cfg);
            mvpalab_savesfdata(cfg,data(sub,:),fv{sub},sub,freq);
        else
            [fv{sub},cfg] = mvpalab_fext(cfg,data(sub,:),sub);
        end
    end
end

%% Save times vector:
cfg.tm.times = EEG.times;
cfg.tm.rtimes = EEG.times;
cfg = mvpalab_timing(cfg);

%% Save channels location:
cfg.chanloc = EEG.chanlocs;

end

