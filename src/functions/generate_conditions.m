function [ classes ] = generate_conditions( conditions , subject )
%GENERATE_CONDITIONS This function reads the subject's data and generate 
%the required structure for the feature extraction.

fprintf([subject '<strong> > Loading subject data... </strong>  \n']);

for i = 1 : length(conditions.names)
    
    load([conditions.dir conditions.names{i} filesep subject])
    classes.(conditions.names{i}) = EEG.data;
    fprintf(['       - Generating condition: ' conditions.names{i} '\n']);
end

fprintf(['       - Done!\n\n']);

end

