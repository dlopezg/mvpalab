function v = mvpalab_getversion()
%% MVPALAB_GETVERSION
%
%  This function returns the version of MVPAlab stored in the variable
%  mvpalab_version of mvpalab_version.mat (see mvpalab_updateversion).
%
%%  OUTPUT:
%
%  - {string} - v:
%    Version of MVPAlab, for example 'v1.2.2'.

load('mvpalab_version','mvpalab_version');
v = mvpalab_version;

end

