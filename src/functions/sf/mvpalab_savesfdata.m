function [] = mvpalab_savesfdata(cfg,data,fv,sub,freq)
%% MVPALAB_SAVESFDATA
%
%  This function saves the feature vectors of one subject in one frequency
%  band of a sliding filter analysis, with cfg, in
%  cfg.sf.filesLocation/fv/s_XXX/ffv_XXX.mat (subject and band). If
%  cfg.sf.savefdata is enabled, it also saves the filtered data, with cfg,
%  in cfg.sf.filesLocation/data/s_XXX/fdata_XXX.mat. It creates the
%  folders if needed.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - data:
%    Filtered data of the subject, one structure per dataset with one
%    field per class (see mvpalab_readdata).
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
dirname = [cfg.sf.filesLocation filesep...
    'fv' filesep 's_' sprintf('%03d',sub)];
mvpalab_mkdir(dirname);
filename = ['ffv_' sprintf('%03d',freq)];
save([dirname filesep filename],'fv','cfg','-v7.3');

if cfg.sf.savefdata
    dirname = [cfg.sf.filesLocation filesep...
        'data' filesep 's_' sprintf('%03d',sub)];
    mvpalab_mkdir(dirname);
    filename = ['fdata_' sprintf('%03d',freq)];
    save([dirname filesep filename],'data','cfg','-v7.3');
end

end

