function mvpalab_dialog(fig, msg, title, icon)
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

