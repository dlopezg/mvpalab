function [] = mvpalab()
%% MVPALAB
%
%  This function adds MVPAlab to the MATLAB path and opens the graphic
%  user interface, which needs MATLAB R2018a or later.

% Update MATLAB paths with subfolders:
loc = which('mvpalab');
%  Hidden folders (names starting with a dot: .git, .claude, .vscode...)
%  are excluded, so copies of the toolbox inside them (e.g. git worktrees)
%  never shadow the functions of this folder.
addpath(genpath_exclude(fileparts(loc),{'\..*','demos'}));

initView;

end
