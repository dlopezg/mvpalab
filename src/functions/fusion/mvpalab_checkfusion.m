function mvpalab_checkfusion(cfg,nconds)
%% MVPALAB_CHECKFUSION
%
%  This function checks the settings of an M/EEG-fMRI fusion analysis
%  before it starts:
%
%  - cfg.fusion.mode is 'mean-fmri' or 'mean-eeg'. The mode 'no-mean'
%    was removed (see mvpalab_fusion).
%  - The settings of the permutation test (see mvpalab_checkstats).
%  - The sign flip test is not available: the observations share the
%    averaged RDM, and flipping their signs does not remove what they
%    share, so it is liberal. The fusion uses the shared permutation test (see
%    mvpalab_fusion).
%  - With cfg.stats.flag, a warning if the null distribution has few maps:
%    the shared permutation test has one null map per permutation, so
%    cfg.stats.nper should be at least 1000, unless every different
%    permutation is used. A warning also if there are fewer than 7
%    conditions (Nili et al., 2014): with n conditions there are only
%    factorial(n) orders, so no p-value is below 1/factorial(n).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.fusion and cfg.stats).
%
%  - {int} - nconds:
%    Number of conditions of the RDMs.

if ~any(strcmp(cfg.fusion.mode,{'mean-fmri','mean-eeg'}))
    error(['cfg.fusion.mode must be ''mean-fmri'' or ''mean-eeg'' ' ...
        '(the mode ''no-mean'' was removed).']);
end

mvpalab_checkstats(cfg);

if cfg.stats.signflip
    error(['The sign flip test is not available in the fusion, because ' ...
        'the observations share the averaged RDM. The fusion ' ...
        'uses a shared permutation of the conditions (see mvpalab_fusion).']);
end

if ~cfg.stats.flag, return; end

if factorial(nconds) - 1 > cfg.stats.nper && cfg.stats.nper < 1000
    warning(['The shared permutation test of the fusion has one null map ' ...
        'per permutation, and cfg.stats.nper = %d. Use at least 1000.'],...
        cfg.stats.nper);
end

if nconds < 7
    warning(['With %d conditions there are only %d permutations, so no ' ...
        'p-value of the fusion can be below 1/%d. Use at least 7 ' ...
        'conditions.'],nconds,factorial(nconds),factorial(nconds));
end

end
