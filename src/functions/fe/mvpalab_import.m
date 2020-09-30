function [cfg, data, fv] = mvpalab_import(cfg)
%GENERATE_CONDITIONS This function reads the subject's data and generate
%the required structure for the feature extraction.

%% Variables initialization:
data = cell(length(cfg.subjects),1);
fv = cell(length(cfg.subjects),1);

if ~cfg.sf.flag
    cfg.sf.nfreq = 1;
end

%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    
    fprintf('<strong> > Importing subject data </strong> - Subject: ');
    fprintf([int2str(sub) '/' int2str(length(cfg.subjects))]);
    fprintf('\n');
    
    subject = cfg.subjects{sub};
    cond = cfg.conditions;
    
    for freq = 1 : cfg.sf.nfreq
        if cfg.sf.flag
            fprintf('  <strong> > Filtering data: </strong>');
            fprintf([int2str(freq) '/' int2str(cfg.sf.nfreq) '\n\n']);
        end
        for ctxt = 1 : size(cond.names,1)
            for class = 1 : size(cond.names,2)
                load([cond.dir cond.names{ctxt,class} filesep subject]);
                cfg.fs = EEG.srate;
                % Sliding filter analysis if needed.
                if cfg.sf.flag
                    EEG.data = mvpalab_filterdata(EEG,freq,cfg);
                end
                classes.(cond.names{ctxt,class}) = EEG.data;
            end
            data{sub,ctxt} = classes;
            clear classes;
        end
        
        if cfg.sf.flag
            [fv{sub},cfg] = mvpalab_fext(cfg,data(sub,:),sub);
            cfg.tm.times = EEG.times;
            cfg.tm.rtimes = EEG.times;
            cfg = mvpalab_timming(cfg);
            mvpalab_savesfdata(cfg,data(sub,:),fv{sub},sub,freq);
        else
            [fv{sub},cfg] = mvpalab_fext(cfg,data(sub,:),sub);
        end
    end
end

%% Save times vector:
cfg.tm.times = EEG.times;
cfg.tm.rtimes = EEG.times;
cfg = mvpalab_timming(cfg);

%% Save channels location:
cfg.chanloc = EEG.chanlocs;


end

