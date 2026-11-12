function [cutoff,ftype] = mvpalab_sfband(cfg,freq)
%% MVPALAB_SFBAND
%
%  This function returns the cutoff frequencies and the filter type of one
%  frequency band of a sliding filter analysis, as pop_firws of EEGLAB
%  takes them. A band from 0 Hz (the first band with cfg.sf.lfreq = 0, see
%  mvpalab_genfreqvec) has one cutoff: removing it ('bandstop') is a
%  high-pass filter and keeping it ('bandpass') a low-pass filter. A
%  band-stop or band-pass filter with a lower cutoff near 0 Hz would not
%  remove or keep the lowest frequencies: the filter cannot resolve
%  frequencies below about fs/cfg.sf.order. mvpalab_filterdata and
%  mvpalab_plotfreqresp use it.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.sf.fcutoff and cfg.sf.ftype).
%
%  - {int} - freq:
%    Index of the frequency band.
%
%%  OUTPUT:
%
%  - {matrix} - cutoff:
%    Cutoff frequencies of the band (Hz): [low high], or high for a band
%    from 0 Hz.
%
%  - {string} - ftype:
%    'bandstop' or 'bandpass', or 'highpass' or 'lowpass' for a band from
%    0 Hz.

cutoff = cfg.sf.fcutoff{freq};
ftype = cfg.sf.ftype;

if cutoff(1) == 0
    cutoff = cutoff(2);
    types = struct('bandstop','highpass','bandpass','lowpass');
    ftype = types.(ftype);
end

end
