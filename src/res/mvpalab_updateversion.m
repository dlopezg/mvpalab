function mvpalab_updateversion(v)
%% MVPALAB_UPDATEVERSION
%
%  This function changes the version of MVPAlab stored in the variable
%  mvpalab_version of mvpalab_version.mat (see mvpalab_getversion). The
%  file is saved in the current folder, so the function must be called
%  from the folder of mvpalab_version.mat (src/res).
%
%%  INPUT:
%
%  - {string} - v:
%    New version of MVPAlab, for example 'v1.2.2'.

load mvpalab_version
mvpalab_version = v;
save('mvpalab_version','mvpalab_version','-append');

end

