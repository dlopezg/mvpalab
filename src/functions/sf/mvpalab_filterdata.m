function [ data ] = mvpalab_filterdata( EEG,freq,cfg)
%% MVPALAB_FILTERDATA
%
%  This function filters the data of one class in one frequency band of a
%  sliding filter analysis with the windowed sinc FIR filter of EEGLAB
%  (pop_firws). The filter uses the cutoff frequencies of the band
%  (cfg.sf.fcutoff), the filter type (cfg.sf.ftype), the window
%  (cfg.sf.wtype) and the order (cfg.sf.order). It needs EEGLAB.
%
%%  INPUT:
%
%  - {struct} - EEG:
%    Data of one subject and class in the EEGLAB format (see
%    mvpalab_dataformat).
%
%  - {int} - freq:
%    Index of the frequency band in cfg.sf.fcutoff.
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {matrix} - data:
%    Filtered data (EEG.data after the filter)
%    [channels x timepoints x trials].

EEG = pop_firws(EEG,...
    'fcutoff', cfg.sf.fcutoff(freq),...
    'ftype', cfg.sf.ftype,...
    'wtype', cfg.sf.wtype,...
    'forder', cfg.sf.order,...
    'minphase', 0);

data = EEG.data;

end

