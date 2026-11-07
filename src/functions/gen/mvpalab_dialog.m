function mvpalab_dialog(fig, msg, title, icon)
%% MVPALAB_DIALOG
%
%  This function shows a message dialog. From MATLAB 9.0 it uses uialert
%  in the figure fig. In older versions it uses msgbox and waits until the
%  dialog is closed; the icons 'warning' and 'info' are changed to 'warn'
%  and 'help'.
%
%%  INPUT:
%
%  - {figure} - fig:
%    Figure of the dialog (used only by uialert).
%
%  - {string} - msg:
%    Message of the dialog.
%
%  - {string} - title:
%    Title of the dialog.
%
%  - {string} - icon:
%    Icon of the dialog, for example 'warning' or 'info'.

if ~verLessThan('matlab','9.0')
    uialert(fig, msg, title, 'Icon', icon);
else
    if strcmp(icon,'warning')
        icon = 'warn';
    elseif strcmp(icon,'info')
        icon = 'help';
    end
    uiwait(msgbox(msg,title,icon));
end
end

