function [] = mvpalab_mkdir(dir)
%% MVPALAB_MKDIR
%
%  This function creates a folder if it doesn't exist.
%
%%  INPUT:
%
%  - {string} - dir:
%    Path of the folder.

    if isdir(dir) == false
        mkdir(dir);
    end
end