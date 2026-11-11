function mvpalab_checkfusion(cfg)
%% MVPALAB_CHECKFUSION
%
%  This function checks the settings of an M/EEG-fMRI fusion analysis
%  before it starts:
%
%  - cfg.fusion.mode is 'mean-fmri', 'mean-eeg' or 'no-mean'.
%  - The sign flip test is not available in the 'no-mean' mode: each
%    observation is a pair of subjects, so the observations are not
%    independent and their signs cannot be flipped.
%  - The settings of the sign flip test (see mvpalab_checksignflip).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.fusion and cfg.stats).

modes = {'mean-fmri','mean-eeg','no-mean'};
if ~any(strcmp(cfg.fusion.mode,modes))
    error('cfg.fusion.mode must be ''mean-fmri'', ''mean-eeg'' or ''no-mean''.');
end

mvpalab_checksignflip(cfg);
if cfg.stats.signflip && strcmp(cfg.fusion.mode,'no-mean')
    error('The sign flip test is not available in the ''no-mean'' fusion mode.');
end

end
