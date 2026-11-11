function mvpalab_checksignflip(cfg,nobs)
%% MVPALAB_CHECKSIGNFLIP
%
%  This function checks the settings of the sign flip test (see
%  mvpalab_signmaps), so an analysis stops before it starts:
%
%  - The maximum cluster size is needed, because the null distribution of
%    all the cluster sizes grows with the effect.
%
%  Leave-one-out in MVPA is checked by mvpalab_checkdecoding.
%
%  With the number of subjects (nobs), it also shows a warning if nothing
%  can be significant. The test has 2^nobs combinations of signs and the
%  observed map is one of them, so no p-value can be below 1/2^nobs. The
%  primary threshold (cfg.stats.pgroup, split between the two tails with
%  cfg.stats.tails = 2) and the cluster level (cfg.stats.pclust) need a
%  smaller p-value: with 3 subjects, for example, no position of the
%  observed map is above the primary threshold. mvpalab_signmaps calls it
%  with nobs once the number of subjects is known.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {int} - nobs:
%    Optional. Number of subjects, or of observations in fusion.

if ~cfg.stats.signflip, return; end

if ~strcmp(cfg.stats.clustcorr,'max')
    error('The sign flip test needs cfg.stats.clustcorr = ''max''.');
end

if nargin < 2, return; end

% Smallest p-value needed by the primary threshold and the cluster level:
level = (100 - cfg.stats.pgroup)/100;
if cfg.stats.tails == 2, level = level/2; end
level = min(level,(100 - cfg.stats.pclust)/100);

if 2^nobs*level <= 1
    warning(['The sign flip test has %d combinations of signs with %d ' ...
        'subjects, so no p-value can be below %.3g and nothing can be ' ...
        'significant with cfg.stats.pgroup = %g, cfg.stats.pclust = %g ' ...
        'and cfg.stats.tails = %d. It needs at least %d subjects.'],...
        2^nobs,nobs,1/2^nobs,cfg.stats.pgroup,cfg.stats.pclust,...
        cfg.stats.tails,floor(log2(1/level)) + 1);
end

end
