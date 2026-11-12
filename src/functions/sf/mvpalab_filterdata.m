function data = mvpalab_filterdata(cfg,EEG,freq)
%% MVPALAB_FILTERDATA
%
%  This function filters the data of one class in one frequency band of a
%  sliding filter analysis with the windowed sinc FIR filter of EEGLAB
%  (pop_firws). The filter uses the cutoff frequencies and the filter type
%  of the band (see mvpalab_sfband), the window
%  (cfg.sf.wtype, with the beta of mvpalab_kaiserbeta for the Kaiser
%  window) and the order (cfg.sf.order). It needs EEGLAB.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - EEG:
%    Data of one subject and class in the EEGLAB format (see
%    mvpalab_dataformat).
%
%  - {int} - freq:
%    Index of the frequency band in cfg.sf.fcutoff.
%
%%  OUTPUT:
%
%  - {matrix} - data:
%    Filtered data (EEG.data after the filter)
%    [channels x timepoints x trials].

[cutoff,ftype] = mvpalab_sfband(cfg,freq);

EEG = pop_firws(EEG,...
    'fcutoff', cutoff,...
    'ftype', ftype,...
    'wtype', cfg.sf.wtype,...
    'warg', mvpalab_kaiserbeta(cfg),...
    'forder', cfg.sf.order,...
    'minphase', 0);

data = EEG.data;

end

