function mvpalab_checkfv(cfg,fv)
%% MVPALAB_CHECKFV
%
%  This function checks that the feature vectors can be used to build
%  supertrials. Feature vectors saved by a previous version already contain
%  supertrials, and averaging them again would give a wrong result.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - fv:
%    Feature vectors of one subject.

if cfg.trialaver.flag && ~isfield(fv,'singletrials')
    error(['These feature vectors already contain supertrials. Import the ' ...
        'data again with this version of MVPAlab.']);
end

end
