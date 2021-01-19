function res = mvpalab_qdialog(fig, msg, title, icon, opt)

if ~verLessThan('matlab','9.3')
    res = uiconfirm(fig, msg, title, 'Icon', icon, 'Options', opt, ...
        'DefaultOption',1,'CancelOption',2);
elseif ~verLessThan('matlab','9.0')
    opts.Default = opt{1};
    opts.Interpreter = 'tex';
    res = questdlg(msg, title, opt{1}, opt{2}, opts);
end

