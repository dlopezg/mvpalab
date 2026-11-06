function mvpalab_checksignflip(cfg)
%% MVPALAB_CHECKSIGNFLIP
%
%  This function checks the settings of the sign flip test (see
%  mvpalab_signmaps), so an analysis stops before it starts:
%
%  - The maximum cluster size is needed, because the null distribution of
%    all the cluster sizes grows with the effect.
%  - Leave-one-out is not available in MVPA: the left-out trial leaves its
%    class with one trial less in the training set, so the accuracy without
%    effect is below 0.5. This also applies to a sliding filter analysis.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.

if ~cfg.stats.signflip, return; end

if ~strcmp(cfg.stats.clustcorr,'max')
    error('The sign flip test needs cfg.stats.clustcorr = ''max''.');
end

if strcmp(cfg.analysis,'MVPA') && strcmp(cfg.cv.method,'loo')
    error('The sign flip test is not available with leave-one-out in MVPA.');
end

end
