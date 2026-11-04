function [] = mvpalab()

% Update MATLAB paths with subfolders:
loc = which('mvpalab');
%  Hidden folders (names starting with a dot: .git, .claude, .vscode...)
%  are excluded, so copies of the toolbox inside them (e.g. git worktrees)
%  never shadow the functions of this folder.
addpath(genpath_exclude(loc(1:end-9),{'\..*','demos'}));


if ~verLessThan('matlab','9.2') %% -v.2017a
    initView; 
else
    msg = {'MVPAlab GUI has not been developed for MATLAB versions older  than 9.2 (r2017a)';
        'You can still use MVPAlab code and functionalities but the graphic user interface may not work propertly.';
        'Do you want to continue?'};
    title = 'Warning';
    opts.Default = 'Exit';
    opts.Interpreter = 'tex';
    res = questdlg(msg, title, 'Launch GUI', 'Exit', opts);
    
    if strcmp(res,'Launch GUI')
        initView;
    end
end

end

