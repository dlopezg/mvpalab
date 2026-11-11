function mvpalab_validatefv(cfg,fv)
%% MVPALAB_VALIDATEFV
%
%  This function checks that the feature vectors can be used to build
%  supertrials. The import marks its feature vectors as single trials
%  (field singletrials, see mvpalab_featurevectors), and the class sizes
%  are applied by the analysis (see mvpalab_preparedata). Feature vectors
%  saved by older versions have no mark: they can contain supertrials, and
%  averaging them again would give a wrong result.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - fv:
%    Feature vectors of one subject.

if cfg.trialaver.flag && ~isfield(fv,'singletrials')
    error(['These feature vectors were imported by an older version of ' ...
        'MVPAlab and can contain supertrials. Import the data again to ' ...
        'build supertrials.']);
end

end
