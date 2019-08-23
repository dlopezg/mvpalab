function [data, cfg] = generate_conditions(cfg)
%GENERATE_CONDITIONS This function reads the subject's data and generate
%the required structure for the feature extraction.

fprintf('<strong> > Loading subject data </strong>');
fprintf('- Subject: ');

%% Variables initialization:
data = cell(length(cfg.subjects),1);

%% Subjects loop:
for sub = 1 : length(cfg.subjects)
    subject = cfg.subjects{sub};
    cond = cfg.conditions;
    
    for ctxt = 1 : size(cond.names,1)
        for class = 1 : size(cond.names,2)
            load([cond.dir cond.names{ctxt,class} filesep subject])
            classes.(cond.names{ctxt,class}) = EEG.data;
        end
        data{sub,ctxt} = classes;
        clear classes;
    end
    
    %% Save times vector and datalength:
    cfg.mvpa.times = EEG.times;
    cfg.mvcc.times = EEG.times;
    cfg.datalength = length(EEG.times);
    cfg.times = EEG.times;
    
    %% Print subject counter:
    print_counter(sub,length(cfg.subjects));
    
end

fprintf(' - Done!\n');

end

