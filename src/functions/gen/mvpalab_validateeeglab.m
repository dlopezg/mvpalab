function mvpalab_validateeeglab()
%% MVPALAB_VALIDATEEEGLAB
%
%  This function checks that EEGLAB is available. If eeglab.m is in the
%  MATLAB path but pop_firws is not, it shows a warning and initializes
%  the EEGLAB paths with 'eeglab nogui'. If eeglab.m is not found, it
%  stops with an error.

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

