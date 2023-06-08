function cfg = mvpalab_genfreqvec(cfg)

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
if lcutoff(1) == 0; lcutoff(1) = 1e-6; end

for i = 1 : length(cfg.sf.freqvec)
   cfg.sf.fcutoff{i} = [lcutoff(i) hcutoff(i)]; 
end
end

