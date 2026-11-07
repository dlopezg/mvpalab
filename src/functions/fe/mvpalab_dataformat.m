function [cfg,EEG] = mvpalab_dataformat(cfg,input)
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
%  EEGLAB files. It also stores the sampling frequency in cfg.fs and the
%  format in cfg.format ('fieldtrip', 'eeglab' or 'mvpalab').
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - input:
%    Content of the file, with the data in its first field (see
%    mvpalab_readdata).
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Configuration structure, with cfg.fs and cfg.format.
%
%  - {struct} - EEG:
%    Data in the EEGLAB format: data [channels x timepoints x trials],
%    srate, nbchan, pnts, trials, times and chanlocs.

% Extract field names:
fields = fieldnames(input);

% Extract data:
input = input.(fields{1});

if isfield(input,'fsample')
    %% Fieldtrip:
    % Store sampling frequency:
    cfg.fs = input.fsample;
    cfg.format = 'fieldtrip';
    
    % Prepare data format:
    EEG.srate = input.fsample;
    EEG.trials = length(input.trial);
    EEG.nbchan = length(input.label);
    EEG.pnts = size(input.trial{1},2);
    EEG.times = input.time{1} * 1000;
    
    if isfield(input,'layout')
        % Not ready yet:
        % EEG.chanlocs = data.layout;
        EEG.chanlocs = [];
    else
        EEG.chanlocs = [];
    end
    
    for trial = 1 : length(input.trial)
        EEG.data(:,:,trial) = input.trial{trial};
    end
    
elseif isfield(input,'srate')
    %% EEGlab:
    % Store sampling frequency:
    cfg.fs = input.srate;
    % Generate data file:
    EEG = input;
    cfg.format = 'eeglab';
    
elseif isfield(input,'format') && strcmp(input.format, 'mvpalab')
    
    cfg.fs = input.fs;
    cfg.format = 'mvpalab';
    
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
    
    % Not ready yet:
    % EEG.chanlocs = data.layout;
    EEG.chanlocs = [];
    
else
    error('Unrecognized data format. Please check your input dataset.')
end

