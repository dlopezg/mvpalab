function mvpalab_validatestats(cfg)
%% MVPALAB_VALIDATESTATS
%
%  This function checks the settings of the permutation test, so a wrong
%  value stops with a clear error before the analysis computes its maps:
%
%  - cfg.stats.tails is 1 (above chance), -1 (below chance) or 2 (both).
%  - cfg.stats.clustcorr is 'fdr' or 'max' (see mvpalab_clusterpvals).
%  - cfg.stats.pgroup and cfg.stats.pclust are percentages above 50 and
%    below 100, for example 95 for p < 0.05, so a p-value such as 0.05 is
%    not taken as a percentage.
%  - cfg.stats.nper and cfg.stats.nperg are whole numbers of at least 1.
%
%  It checks them even if cfg.stats.flag is disabled, because the test
%  can also be run after the analysis (see mvpalab_permtest).
%  mvpalab_validatedecoding, mvpalab_validatersa, mvpalab_validatefusion
%  and mvpalab_computepermtest call it. The sign flip test is checked by
%  mvpalab_validatesignflip.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.stats).

s = cfg.stats;

if ~isscalar(s.tails) || ~ismember(s.tails,[-1 1 2])
    error('cfg.stats.tails must be 1 (above chance), -1 (below chance) or 2.');
end

if ~any(strcmp(s.clustcorr,{'fdr','max'}))
    error('cfg.stats.clustcorr must be ''fdr'' or ''max''.');
end

for field = {'pgroup','pclust'}
    level = s.(field{1});
    if ~isscalar(level) || ~(level > 50 && level < 100)
        error(['cfg.stats.%s must be a percentage above 50 and below 100, ' ...
            'for example 95 for p < 0.05.'],field{1});
    end
end

for field = {'nper','nperg'}
    n = s.(field{1});
    if ~isscalar(n) || n < 1 || n ~= round(n)
        error('cfg.stats.%s must be a whole number of at least 1.',field{1});
    end
end

end
