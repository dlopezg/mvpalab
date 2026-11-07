function mvpalab_savecfg(cfg)
%% MVPALAB_SAVECFG
%
%  This function saves the configuration structure in cfg.location as
%  cfg.mat (MAT-file version 7.3). It creates the folder cfg.location if it
%  does not exist.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.

mvpalab_mkdir(cfg.location);
save(fullfile(cfg.location,'cfg.mat'),'cfg','-v7.3');

end
