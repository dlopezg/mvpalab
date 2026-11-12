function mvpalab_sffolders(cfg)
%% MVPALAB_SFFOLDERS
%
%  This function prepares the folders of a sliding filter analysis. If the
%  folder cfg.sf.filesLocation exists, it removes the filtered data of a
%  previous import, so its files do not stay next to the new ones (see
%  mvpalab_cleansfdata). Then it creates cfg.sf.filesLocation.
%  The folder of the results is created by mvpalab_sfilter.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (see mvpalab_preparesf).

if exist(cfg.sf.filesLocation,'dir')
    mvpalab_cleansfdata(cfg);
end

mvpalab_mkdir(cfg.sf.filesLocation);

end
