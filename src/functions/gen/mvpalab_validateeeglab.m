function mvpalab_validateeeglab()
%% MVPALAB_VALIDATEEEGLAB
%
%  This function checks that EEGLAB is available. If eeglab.m is in the
%  MATLAB path but pop_firws is not, it shows a warning and initializes
%  the EEGLAB paths with 'eeglab nogui'. If eeglab.m is not found, it
%  stops with an error.

if exist('eeglab.m','file')
    if ~exist('pop_firws','file')
        warning('mvpalab:validateeeglab','Initializing EEGLAB paths...');
        eeglab nogui
    end
else
    error('mvpalab:validateeeglab',...
        'EEGlab not found. EEGlab is required to compute this analysis');
end

end

