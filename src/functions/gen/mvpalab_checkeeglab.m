function mvpalab_checkeeglab()

if exist('eeglab.m','file')
    if ~exist('pop_firws','file')
        warning('Starting EEGlab for filter the data');
        eeglab;
    end
else
    error('EEGlab not found. EEGlab is required to compute this analysis');
end

end

