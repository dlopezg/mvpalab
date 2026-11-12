function cfg = mvpalab_genfreqvec(cfg)
%% MVPALAB_GENFREQVEC
%
%  This function generates the frequency bands of a sliding filter
%  analysis. The half bandwidth cfg.sf.hbw is half of the bandwidth
%  cfg.sf.bw. The cfg.sf.nfreq center frequencies go from
%  cfg.sf.lfreq + cfg.sf.hbw to cfg.sf.hfreq - cfg.sf.hbw, with a
%  logarithmic spacing if cfg.sf.fspac is 'log' and a linear spacing
%  otherwise. The cutoff frequencies of each band are its center frequency
%  minus and plus cfg.sf.hbw. A low cutoff below 1e-6 Hz is set to 0: the
%  band starts at 0 Hz and is filtered with one cutoff (see
%  mvpalab_sfband).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.sf.lfreq, cfg.sf.hfreq, cfg.sf.bw,
%    cfg.sf.nfreq and cfg.sf.fspac).
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    The same structure with:
%    - cfg.sf.hbw: Half bandwidth (Hz).
%    - cfg.sf.freqvec: Center frequency of each band [1 x bands].
%    - cfg.sf.fcutoff: Cutoff frequencies of each band, one cell per band
%      with [low high].

cfg.sf.hbw = cfg.sf.bw/2;

lfreq = cfg.sf.lfreq + cfg.sf.hbw;
hfreq = cfg.sf.hfreq - cfg.sf.hbw;

if strcmp(cfg.sf.fspac,'log')
    cfg.sf.freqvec = logspace(log10(lfreq),log10(hfreq),cfg.sf.nfreq);
else
    cfg.sf.freqvec = linspace(lfreq,hfreq,cfg.sf.nfreq);
end

lcutoff = cfg.sf.freqvec - cfg.sf.hbw;
lcutoff(lcutoff < 1e-6) = 0;
hcutoff = cfg.sf.freqvec + cfg.sf.hbw;
cfg.sf.fcutoff = num2cell([lcutoff' hcutoff'],2)';

end
