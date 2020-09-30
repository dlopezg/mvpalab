function cfg = mvpalab_plotfreqresp(cfg)

    % Select FS:
    if isfield(cfg,'fs')
        cfg.sf.fs = cfg.fs;
    else
        cfg.sf.fs = 250;
    end

    % Cutoff frequencies:
    f = cfg.sf.fcutoff{1}/(cfg.sf.fs/2);

    % Type:
    if strcmp(cfg.sf.ftype,'bandstop')
        type = 'stop';
    else
        type = 'bandpass';
    end

    % Generate the window:
    cfg.sf.win = windows(cfg.sf.wtype,cfg.sf.order+1);

    % Calculate the filter coefficients
    cfg.sf.coeff = firws(cfg.sf.order,f,type,cfg.sf.win);

    % Plot frequency response:
    nfft = cfg.sf.fs*10;
    plotfresp(cfg.sf.coeff,[],nfft,cfg.sf.fs);

end

