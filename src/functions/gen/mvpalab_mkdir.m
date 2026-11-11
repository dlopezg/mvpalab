function mvpalab_mkdir(folder)
%% MVPALAB_MKDIR
%
%  This function creates a folder, with its parent folders, if it does not
%  exist.
%
%%  INPUT:
%
%  - {string} - folder:
%    Path of the folder.

if ~isfolder(folder), mkdir(folder); end

end
