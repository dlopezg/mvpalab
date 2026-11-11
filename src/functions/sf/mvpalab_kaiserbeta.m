function beta = mvpalab_kaiserbeta(cfg)
%% MVPALAB_KAISERBETA
%
%  This function returns the parameter beta of the Kaiser window of the
%  sliding filter, for a stopband attenuation of -60 dB, the one shown by
%  the GUI: a maximum deviation of 10^(-60/20) = 0.001, converted to beta
%  by kaiserbeta of EEGLAB (about 5.65). The other windows have no
%  parameter, so it returns an empty value. mvpalab_filterdata passes it
%  to pop_firws ('warg') and mvpalab_plotfreqresp to windows, so the
%  filter and its plot use the same window. It needs EEGLAB.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.sf.wtype).
%
%%  OUTPUT:
%
%  - {double} - beta:
%    Beta of the Kaiser window, or empty for the other windows.

beta = [];
if strcmp(cfg.sf.wtype,'kaiser')
    beta = kaiserbeta(10^(-60/20));
end

end
