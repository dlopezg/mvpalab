function [] = mvpalab_savesfdata(cfg,data,fv,sub,freq)
%% MVPALAB_SAVESFDATA
%
%  This function saves the feature vectors of one subject in one frequency
%  band of a sliding filter analysis, with cfg, in
%  cfg.sf.filesLocation/fv/s_XXX/ffv_XXX.mat (subject and band). If
%  cfg.sf.savefdata is enabled, it also saves the filtered data, with cfg,
%  in cfg.sf.filesLocation/data/s_XXX/fdata_XXX.mat (see mvpalab_sffile).
%  It creates the folders if needed.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - data:
%    Filtered data of the subject, one structure per dataset with one
%    field per class (see mvpalab_classdata).
%
%  - {struct} - fv:
%    Feature vectors of the subject (see mvpalab_fext).
%
%  - {int} - sub:
%    Index of the subject.
%
%  - {int} - freq:
%    Index of the frequency band.

fprintf('    <strong> - Saving data and feature vectors.</strong>\n\n\n');
file = mvpalab_sffile(cfg,'fv',sub,freq);
mvpalab_mkdir(fileparts(file));
save(file,'fv','cfg','-v7.3');

if cfg.sf.savefdata
    file = mvpalab_sffile(cfg,'data',sub,freq);
    mvpalab_mkdir(fileparts(file));
    save(file,'data','cfg','-v7.3');
end

end

