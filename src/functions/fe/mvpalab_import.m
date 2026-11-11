function [cfg, data, fv] = mvpalab_import(cfg)
%% MVPALAB_IMPORT
%
%  This function starts an analysis: it checks the configuration structure
%  and saves it, prepares the frequency bands of a sliding filter analysis
%  (see mvpalab_preparesf), checks its settings before reading any file
%  (see mvpalab_validateimport) and reads the data of each subject (see
%  mvpalab_readdata). It saves the configuration again at the end, with the
%  fields set by the import.
%
%  The study is a cross-classification (MVCC) if dataset B has files (see
%  mvpalab_ismvcc). The feature vectors keep all the single trials: the
%  supertrials and the class sizes are applied by each analysis (see
%  mvpalab_preparedata).
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
%    Feature vectors of each subject (see mvpalab_featurevectors).

% Check cfg integrity and backwards compatibility:
cfg = mvpalab_updatecfg(cfg);
mvpalab_savecfg(cfg);

% Settings of the study and checks before reading any file:
if cfg.sf.flag, cfg = mvpalab_preparesf(cfg); end
mvpalab_validateimport(cfg);

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
