function mvpalab_dialog(fig,msg,title,icon)
%% MVPALAB_DIALOG
%
%  This function shows a message dialog in the figure fig (uialert). The
%  GUI needs MATLAB R2018a or later, so uialert is always available.
%
%%  INPUT:
%
%  - {figure} - fig:
%    Figure of the dialog.
%
%  - {string} - msg:
%    Message of the dialog.
%
%  - {string} - title:
%    Title of the dialog.
%
%  - {string} - icon:
%    Icon of the dialog, for example 'warning' or 'info'.

uialert(fig, msg, title, 'Icon', icon);

end
