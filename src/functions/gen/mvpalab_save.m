function mvpalab_save(cfg,data,mode,folder)
%% MVPALAB_SAVE
%
% This function recursively iterates over the fields of the input data 
% structure and saves the content of each field in the results folder.
% This function is compatible with the following data structures:
%  - Results.
%  - Permuted maps.
%  - Statistics.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Description: Configuration structure.
%
%  - {struct} data
%    Description: Data structure containing the data to save for each 
%    measure.
%
%  - {string} mode
%    Description: Save modality: 'stats' - 'res' - 'permaps'
%
%  - {string} folder
%    Description: Current folder name used for the recursive call. 
%

%% Initialize the recursive function:
%  If this call is the initial one, initialize the recursive algorithm:

if nargin < 4
    
    % Show information to the user:
    if strcmp(mode,'stats')
        fprintf('<strong> > Saving stats: </strong>');
    elseif strcmp(mode,'res')
        fprintf('<strong> > Saving results: </strong>');
    elseif strcmp(mode,'permaps')
        fprintf('<strong> > Saving permuted maps: </strong>');
    end
    
    % Initialize the saving folder:
    if cfg.classmodel.tempgen
        folder = 'temporal_generalization';
    else
        folder = 'time_resolved';
    end
    
end

%% Check if the current input is a struct:
%  Description: If the current input is a struct we extract its field names
%  and make a recursive call for each field. 
%  Special case: In the stats structure we don't need to iterate over the
%  last level. (This level includes fields such as 'sigmask')

if isstruct(data) && ~any(find(strcmp(fieldnames(data),'sigmask')))
    field_names = fieldnames(data);
    for i = 1 : length(field_names)
        fname = field_names{i};
        stats = data.(fname);
        mvpalab_save(cfg,stats,mode,[folder filesep fname]);
    end
else
    %% Save the content of the current input:
    %  Description: If the current input is not a structure or is a stats
    %  structure we save the content in the requiered location.

    save_folder = [cfg.location filesep 'results' filesep folder];
    mvpalab_mkdir(save_folder);
    
    if strcmp(mode,'stats')
        stats = data;
        save([save_folder filesep 'stats.mat'], 'stats','cfg','-v7.3');
    elseif strcmp(mode,'res')
        result = data;
        save([save_folder filesep 'result.mat'], 'result','cfg','-v7.3');
    elseif strcmp(mode,'permaps')
        permaps = data;
        save([save_folder filesep 'permaps.mat'], 'permaps','cfg','-v7.3');
    end
    
    
end

end

