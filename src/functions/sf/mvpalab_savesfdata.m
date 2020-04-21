function [] = mvpalab_savesfdata(cfg,data,fv,sub,freq)
%MVPALAB_SAVESFDATA Summary of this function goes here
%   Detailed explanation goes here

fprintf('    <strong> - Saving data and feature vectors.</strong>\n\n\n');
dirname = [cfg.dir.savedir filesep...
    'fv' filesep 's_' sprintf('%03d',sub)];
mvpalab_mkdir(dirname);
filename = ['ffv_' sprintf('%03d',freq)];
save([dirname filesep filename],'fv','cfg');

dirname = [cfg.dir.savedir filesep...
    'data' filesep 's_' sprintf('%03d',sub)];
mvpalab_mkdir(dirname);
filename = ['fdata_' sprintf('%03d',freq)];
save([dirname filesep filename],'data','cfg');

end

