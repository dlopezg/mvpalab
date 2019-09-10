function cfg = generate_conditions_sf(cfg)
%GENERATE_CONDITIONS This function reads the subject's data and generate
%the required structure for the feature extraction.

fprintf('<strong> > Loading subject data </strong>\n');

%% Variables initialization:
data = cell(length(cfg.subjects),1);

%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    tic
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(length(cfg.subjects)) '\n']);
    subject = cfg.subjects{sub};
    cond = cfg.conditions;
    for freq = 1 : cfg.sf.nfreq
        fprintf(['   - Freq: ' int2str(freq) '/' int2str(cfg.sf.nfreq) '\n']);
        for ctxt = 1 : size(cond.names,1)
            for class = 1 : size(cond.names,2)
                load([cond.dir cond.names{ctxt,class} filesep subject])
                EEG_filtered = pop_firws(EEG,...
                    'fcutoff', cfg.sf.fcutoff(freq),...
                    'ftype', cfg.sf.ftype,...
                    'wtype', cfg.sf.wtype,...
                    'forder', cfg.sf.order,...
                    'minphase', 0);
                classes.(cond.names{ctxt,class}) = EEG_filtered.data;
            end
            data{ctxt} = classes;
            clear classes;
        end
        
        %% Save times vector and datalength:
        cfg.mvpa.times = EEG.times;
        cfg.sf.times = EEG.times;
        cfg.datalength = length(EEG.times);
        cfg.times = EEG.times;
        
        [cfg,fv] = feature_extraction_sf(cfg,data);
        
        dirname = [cfg.conditions.savedir filesep 's_' sprintf('%03d',sub)];
        create_folder(dirname);
        filename = ['fv_filtered_' sprintf('%03d',freq)];
        save([dirname filesep filename],'fv','cfg');
    end
end

fprintf(' - Done!\n');

end

