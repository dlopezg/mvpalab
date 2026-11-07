function cfg = mvpalab_genfreqvec(cfg)
%% MVPALAB_GENFREQVEC
%
%  This function generates the frequency bands of a sliding filter
%  analysis. The cfg.sf.nfreq center frequencies go from
%  cfg.sf.lfreq + cfg.sf.hbw to cfg.sf.hfreq - cfg.sf.hbw, with a
%  logarithmic spacing if cfg.sf.fspac is 'log' and a linear spacing
%  otherwise. The cutoff frequencies of each band are its center frequency
%  minus and plus cfg.sf.hbw, and the low cutoff of the first band is at
%  least 1e-6 Hz.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.sf.lfreq, cfg.sf.hfreq, cfg.sf.hbw,
%    cfg.sf.nfreq and cfg.sf.fspac).
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure:
%    - cfg.sf.freqvec: Center frequencies [1 x nfreq].
%    - cfg.sf.fcutoff: Cell array {1 x nfreq} with the cutoff frequencies
%      [low high] of each band.

cfg.sf.fcutoff = [];
cfg.sf.freqvec = [];

if strcmp(cfg.sf.fspac,'log')
    cfg.sf.freqvec = logspace(log10(cfg.sf.lfreq + cfg.sf.hbw),log10(cfg.sf.hfreq - cfg.sf.hbw), cfg.sf.nfreq);
else
    cfg.sf.freqvec = linspace(cfg.sf.lfreq + cfg.sf.hbw, cfg.sf.hfreq - cfg.sf.hbw, cfg.sf.nfreq);
    cfg.sf.nfreq = length(cfg.sf.freqvec);
end

hcutoff = cfg.sf.freqvec + cfg.sf.hbw;
lcutoff = cfg.sf.freqvec - cfg.sf.hbw;
if lcutoff(1) < 1e-6; lcutoff(1) = 1e-6; end

for i = 1 : length(cfg.sf.freqvec)
   cfg.sf.fcutoff{i} = [lcutoff(i) hcutoff(i)]; 
end
end

