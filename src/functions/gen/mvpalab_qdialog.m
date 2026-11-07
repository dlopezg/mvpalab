function res = mvpalab_qdialog(fig, msg, title, icon, opt)
%% MVPALAB_QDIALOG
%
%  This function shows a question dialog with two options. From MATLAB 9.3
%  it uses uiconfirm in the figure fig, with the first option as default
%  and the second one as cancel. From MATLAB 9.0 it uses questdlg, with the
%  first option as default; fig and icon are not used. Older versions are
%  not supported: res is not assigned.
%
%%  INPUT:
%
%  - {figure} - fig:
%    Figure of the dialog (used only by uiconfirm).
%
%  - {string} - msg:
%    Message of the dialog.
%
%  - {string} - title:
%    Title of the dialog.
%
%  - {string} - icon:
%    Icon of the dialog (used only by uiconfirm).
%
%  - {cell array} - opt:
%    Options of the dialog {option1, option2}.
%
%%  OUTPUT:
%
%  - {string} - res:
%    Option selected by the user.

if ~verLessThan('matlab','9.3')
    res = uiconfirm(fig, msg, title, 'Icon', icon, 'Options', opt, ...
        'DefaultOption',1,'CancelOption',2);
elseif ~verLessThan('matlab','9.0')
    opts.Default = opt{1};
    opts.Interpreter = 'tex';
    res = questdlg(msg, title, opt{1}, opt{2}, opts);
end

