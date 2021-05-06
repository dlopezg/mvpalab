function mvpalab_checkeeglab()

if exist('eeglab.m','file')
    if ~exist('pop_firws','file')
        warning('Initializing EEGLAB paths...');
        eeglab nogui
        %% Other alternative:
        % eeglabFolder = fileparts(which('eeglab.m'));
        % addpath(genpath(eeglabFolder));
        % warning('EEGLAB subfolders added to the MATLAB Path.');
    end
else
    error('EEGlab not found. EEGlab is required to compute this analysis');
end

end

