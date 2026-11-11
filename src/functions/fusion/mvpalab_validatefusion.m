function mvpalab_validatefusion(cfg)
%% MVPALAB_VALIDATEFUSION
%
%  This function checks the settings of an M/EEG-fMRI fusion analysis
%  before it starts:
%
%  - cfg.fusion.mode is 'mean-fmri' or 'mean-eeg'. The mode 'no-mean'
%    was removed (see mvpalab_fusion).
%  - The settings of the permutation test (see mvpalab_validatestats).
%  - The sign flip test is not available: the observations share the
%    averaged RDM, and flipping their signs does not remove what they
%    share, so it is liberal. The fusion uses the shared permutation test
%    (see mvpalab_fusionnullmaps), which warns about too few permutations
%    or conditions.
%
%  mvpalab_fusion and mvpalab_fusionnullmaps call it.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.fusion and cfg.stats).

if ~any(strcmp(cfg.fusion.mode,{'mean-fmri','mean-eeg'}))
    error(['cfg.fusion.mode must be ''mean-fmri'' or ''mean-eeg'' ' ...
        '(the mode ''no-mean'' was removed).']);
end

mvpalab_validatestats(cfg);

if cfg.stats.signflip
    error(['The sign flip test is not available in the fusion, because ' ...
        'the observations share the averaged RDM. The fusion ' ...
        'uses a shared permutation of the conditions (see mvpalab_fusion).']);
end

end
