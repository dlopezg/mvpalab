function EEG = mvpalab_dataformat(input)
%% MVPALAB_DATAFORMAT
%
%  This function reads the content of one data file and returns its data
%  in the EEGLAB format used by MVPAlab. The format is detected from the
%  fields of the data:
%
%  - FieldTrip (field fsample): the trials are concatenated in EEG.data
%    and the times of the first trial are converted to milliseconds.
%  - EEGLAB (field srate): the structure is used as it is.
%  - MVPAlab (field format = 'mvpalab'): fields data, fs and, optionally,
%    times. Without times, the time vector is 1 to the number of
%    timepoints and a warning is shown.
%
%  Any other format gives an error. Channel locations are only kept from
%  EEGLAB files.
%
%%  INPUT:
%
%  - {struct} - input:
%    Content of the file, with the data in its first field (see
%    mvpalab_loadfile).
%
%%  OUTPUT:
%
%  - {struct} - EEG:
%    Data in the EEGLAB format: data [channels x timepoints x trials],
%    srate, nbchan, pnts, trials, times and chanlocs.

% Extract data:
fields = fieldnames(input);
input = input.(fields{1});

if isfield(input,'fsample')
    %% Fieldtrip:
    EEG.srate = input.fsample;
    EEG.trials = length(input.trial);
    EEG.nbchan = length(input.label);
    EEG.pnts = size(input.trial{1},2);
    EEG.times = input.time{1} * 1000;
    EEG.chanlocs = [];
    EEG.data = cat(3,input.trial{:});

elseif isfield(input,'srate')
    %% EEGlab:
    EEG = input;

elseif isfield(input,'format') && strcmp(input.format, 'mvpalab')
    %% MVPAlab:
    EEG.data = input.data;
    EEG.srate = input.fs;
    EEG.nbchan = size(input.data,1);
    EEG.pnts = size(input.data,2);
    EEG.trials = size(input.data,3);

    if isfield(input,'times')
        EEG.times = input.times;
    else
        EEG.times = 1:EEG.pnts;
        warning('No time vector found. A default time vector will be created. Please define your time vector for a better temporal precision.')
    end

    EEG.chanlocs = [];

else
    error('Unrecognized data format. Please check your input dataset.')
end

end
