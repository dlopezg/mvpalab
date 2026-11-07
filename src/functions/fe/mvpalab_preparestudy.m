function cfg = mvpalab_preparestudy(cfg)
%% MVPALAB_PREPARESTUDY
%
%  This function sets the fields of cfg that depend on the study and not on
%  the data, before any file is read:
%
%  - cfg.analysis is 'MVCC' if every class of dataset B has its files
%    (second row of cfg.study.dataFiles). Otherwise it does not change, so
%    RSA keeps its own analysis.
%  - In a sliding filter analysis, the settings of the frequency bands
%    (see mvpalab_preparesf).
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

if all(~cellfun(@isempty,cfg.study.dataFiles(2,:)))
    cfg.analysis = 'MVCC';
end

if cfg.sf.flag, cfg = mvpalab_preparesf(cfg); end

end
