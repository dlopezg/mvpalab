function [cfg, data, fv] = mvpalab_import(cfg)
%% MVPALAB_IMPORT
%
%  This function starts an analysis: it checks the configuration structure
%  and saves it, prepares the study (see mvpalab_preparestudy), checks its
%  files before reading any of them (see mvpalab_checkstudy) and reads the
%  data of each subject (see mvpalab_readdata). It saves the configuration
%  again at the end, with the fields set by the import.
%
%  In a sliding filter analysis the data of each band is saved in
%  cfg.sf.filesLocation (see mvpalab_readsfdata), so data and fv are empty.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure.
%
%  - {cell array} - data:
%    Data of each subject and dataset (see mvpalab_classdata).
%
%  - {cell array} - fv:
%    Feature vectors of each subject (see mvpalab_fext).

% Check cfg integrity and backwards compatibility:
cfg = mvpalab_checkcfg(cfg);
mvpalab_savecfg(cfg);

% Settings of the study and checks before reading any file:
cfg = mvpalab_preparestudy(cfg);
mvpalab_checkstudy(cfg);
mvpalab_checksignflip(cfg);
mvpalab_checkclasses(cfg);

% EEGLAB reads the .set files and filters the frequency bands:
files = [cfg.study.dataFiles{:}];
if cfg.sf.flag || any(endsWith(lower(files),'.set'))
    mvpalab_checkeeglab();
end

if cfg.sf.flag
    mvpalab_sffolders(cfg);
    cfg = mvpalab_readsfdata(cfg);
    data = [];
    fv = [];
else
    [cfg,data,fv] = mvpalab_readdata(cfg);
end

% Save the configuration with the fields set by the import:
mvpalab_savecfg(cfg);

end
