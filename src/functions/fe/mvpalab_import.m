function [cfg, data, fv] = mvpalab_import(cfg)
%% MVPALAB_IMPORT
%
%  This function starts an analysis: it checks the configuration structure,
%  saves it and reads the data of each subject (see mvpalab_readdata).
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
%    Data of each subject and dataset.
%
%  - {cell array} - fv:
%    Feature vectors of each subject.

% Check cfg integrity and backwards compatibility:
cfg = mvpalab_checkcfg(cfg);
mvpalab_savecfg(cfg);

[cfg,data,fv] = mvpalab_readdata(cfg);

end
