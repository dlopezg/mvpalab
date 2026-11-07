function file = mvpalab_sffile(cfg,kind,sub,freq)
%% MVPALAB_SFFILE
%
%  This function returns the file of one subject and frequency band of a
%  sliding filter analysis in cfg.sf.filesLocation:
%
%  - 'fv': feature vectors, fv/s_XXX/ffv_XXX.mat.
%  - 'data': filtered data, data/s_XXX/fdata_XXX.mat.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.sf.filesLocation).
%
%  - {string} - kind:
%    'fv' or 'data'.
%
%  - {int} - sub:
%    Subject.
%
%  - {int} - freq:
%    Frequency band.
%
%%  OUTPUT:
%
%  - {string} - file:
%    Full path of the file.

prefix = struct('fv','ffv_','data','fdata_');

file = fullfile(cfg.sf.filesLocation,kind,sprintf('s_%03d',sub),...
    sprintf('%s%03d.mat',prefix.(kind),freq));

end
