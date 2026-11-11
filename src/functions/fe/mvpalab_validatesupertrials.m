function mvpalab_validatesupertrials(cfg)
%% MVPALAB_VALIDATESUPERTRIALS
%
%  This function checks the settings of the supertrials before an
%  analysis loads any subject. The supertrials are built by the analysis
%  (see mvpalab_supertrials), so these settings can change after the
%  import. With cfg.trialaver.flag enabled:
%
%  - cfg.trialaver.ntrials is a whole number of at least 1.
%  - cfg.trialaver.order is 'rand' (random blocks) or 'seq' (consecutive
%    blocks).
%
%  Each class also needs at least cfg.trialaver.ntrials trials, which
%  depends on the data, so mvpalab_supertrials checks it.
%  mvpalab_validatedecoding and mvpalab_validatersa call it.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.trialaver).

if ~cfg.trialaver.flag, return; end

ntrials = cfg.trialaver.ntrials;
if ~isscalar(ntrials) || ntrials < 1 || ntrials ~= round(ntrials)
    error('cfg.trialaver.ntrials must be a whole number of at least 1.');
end

if ~any(strcmp(cfg.trialaver.order,{'rand','seq'}))
    error('cfg.trialaver.order must be ''rand'' or ''seq''.');
end

end
