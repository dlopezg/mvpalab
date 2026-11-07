function res = mvpalab_qdialog(fig, msg, title, icon, opt)
%% MVPALAB_QDIALOG
%
%  This function shows a question dialog with two options in the figure
%  fig (uiconfirm), with the first option as default and the second one as
%  cancel. The GUI needs MATLAB R2018a or later, so uiconfirm is always
%  available.
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
%    Icon of the dialog.
%
%  - {cell array} - opt:
%    Options of the dialog {option1, option2}.
%
%%  OUTPUT:
%
%  - {string} - res:
%    Option selected by the user.

res = uiconfirm(fig, msg, title, 'Icon', icon, 'Options', opt, ...
    'DefaultOption',1,'CancelOption',2);

end
