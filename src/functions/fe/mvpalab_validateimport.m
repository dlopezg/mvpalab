function mvpalab_validateimport(cfg)
%% MVPALAB_VALIDATEIMPORT
%
%  This function checks the settings of the import before any file is
%  read, so a wrong setting stops with a clear error instead of failing
%  after some subjects have been read:
%
%  - The files of the study (see mvpalab_validatestudy).
%  - The feature extraction (see mvpalab_validatefeatures).
%  - The settings of the sign flip test (see mvpalab_validatesignflip).
%  - The classes of the analysis (see mvpalab_validateclasses).
%  - EEGLAB, if it reads the .set files or filters the frequency bands of
%    a sliding filter analysis (see mvpalab_validateeeglab).
%  - The filter settings of a sliding filter analysis, before the filtered
%    data of a previous analysis is removed (see mvpalab_validatesf).
%
%  The methods of each analysis are checked by the analysis (see
%  mvpalab_validatedecoding and mvpalab_validatersa), because the import
%  does not use them and they can change after the import.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure, with the frequency bands of a sliding filter
%    analysis (see mvpalab_preparesf).

mvpalab_validatestudy(cfg);
mvpalab_validatefeatures(cfg);
mvpalab_validatesignflip(cfg);
mvpalab_validateclasses(cfg);

files = [cfg.study.dataFiles{:}];
if cfg.sf.flag || any(endsWith(lower(files),'.set'))
    mvpalab_validateeeglab();
end

if cfg.sf.flag, mvpalab_validatesf(cfg); end

end
