function mvpalab_checkimport(cfg)
%% MVPALAB_CHECKIMPORT
%
%  This function checks the settings of the import before any file is
%  read, so a wrong setting stops with a clear error instead of failing
%  after some subjects have been read:
%
%  - The files of the study (see mvpalab_checkstudy).
%  - The methods of the analysis (see mvpalab_checkmethods).
%  - The settings of the sign flip test (see mvpalab_checksignflip).
%  - The classes of the analysis (see mvpalab_checkclasses).
%  - EEGLAB, if it reads the .set files or filters the frequency bands of
%    a sliding filter analysis (see mvpalab_checkeeglab).
%  - The filter settings of a sliding filter analysis, before the filtered
%    data of a previous analysis is removed (see mvpalab_checksf).
%
%  The analyses check their own settings again (see mvpalab_checkdecoding),
%  because they can run with feature vectors imported in another session.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure, with the settings of the study (see
%    mvpalab_preparestudy).

mvpalab_checkstudy(cfg);
mvpalab_checkmethods(cfg);
mvpalab_checksignflip(cfg);
mvpalab_checkclasses(cfg);

files = [cfg.study.dataFiles{:}];
if cfg.sf.flag || any(endsWith(lower(files),'.set'))
    mvpalab_checkeeglab();
end

if cfg.sf.flag, mvpalab_checksf(cfg); end

end
