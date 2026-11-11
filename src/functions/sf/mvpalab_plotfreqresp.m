function cfg = mvpalab_plotfreqresp(cfg)
%% MVPALAB_PLOTFREQRESP
%
%  This function plots, in a new figure, the magnitude response of the
%  filter of each frequency band, computed with firws and windows of
%  EEGLAB from cfg.sf.wtype (with the beta of mvpalab_kaiserbeta for the
%  Kaiser window, as the filter) and cfg.sf.order. The filter is
%  band-stop if cfg.sf.ftype is 'bandstop' and band-pass if it is
%  'bandpass', the two types accepted (see mvpalab_checksf). The x axis
%  goes up to cfg.sf.hfreq. It needs EEGLAB and the bands in
%  cfg.sf.fcutoff (see mvpalab_genfreqvec). The first subplot shows the
%  bands of cfg.sf.fspac, and the second one the bands generated again
%  with the other spacing ('lin' or 'log'). The titles of the subplots are
%  fixed (log spacing, then linear spacing), so they are right when
%  cfg.sf.fspac is 'log'. The sampling rate is cfg.fs, or 250 Hz if cfg
%  has no field fs.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure: cfg.sf.fs, cfg.sf.win and
%    cfg.sf.coeff, and cfg.sf.fspac, cfg.sf.freqvec and cfg.sf.fcutoff
%    changed to the other spacing.

    % Check if EEGlab is installed.
    mvpalab_checkeeglab();
    
    % Select FS:
    if isfield(cfg,'fs')
        cfg.sf.fs = cfg.fs;
    else
        cfg.sf.fs = 250;
    end

    % Type:
    if strcmp(cfg.sf.ftype,'bandstop')
        type = 'stop';
    else
        type = 'bandpass';
    end
    
    load mvpalab_colorschemes.mat
    color = 1;
    limit = 350;
    figure; 
    subplot(2,1,1)
    hold on;
    
    for i = length(cfg.sf.fcutoff) : -1 : 1
        % Generate the window:
        cfg.sf.win = windows(cfg.sf.wtype,cfg.sf.order+1,...
            mvpalab_kaiserbeta(cfg));

        % Calculate the filter coefficients
        f = cfg.sf.fcutoff{i}/(cfg.sf.fs/2);
        cfg.sf.coeff = firws(cfg.sf.order,f,type,cfg.sf.win);

        % Plot frequency response:
        nfft = cfg.sf.fs * 10;
        
        impresp = cfg.sf.coeff(:)';
        n = length(impresp);

        nfft = max([2^ceil(log2(n)) nfft]);
        f = linspace(0, cfg.sf.fs / 2, nfft / 2 + 1);
        z = fft(impresp, nfft);
        z = z(1:nfft / 2 + 1);
        
        % Color gradient:
        shift = floor(limit/length(cfg.sf.fcutoff)) - 1;
        color = color + shift;
        index = limit - color;
        
        if index == 0
            index = 1;
        end
        
        % Plot magnitude response:
        plot(f, 20 * log10(abs(z)), 'LineWidth',1,...
            'Color', grd.neptune(index,:));
    end
    
    % Titles and axis:
    title('Magnitude response (log spacing)');
    ylabel('Magnitude (dB)');
    xlabel('Frequency (Hz)');
    xlim([0,cfg.sf.hfreq]);
    
    if strcmp(cfg.sf.fspac,'lin')
        cfg.sf.fspac = 'log';
    else
        cfg.sf.fspac = 'lin';
    end
    cfg = mvpalab_genfreqvec(cfg);
    color = 1;
    subplot(2,1,2)
    hold on;
    for i = length(cfg.sf.fcutoff) : -1 : 1
        % Generate the window:
        cfg.sf.win = windows(cfg.sf.wtype,cfg.sf.order+1,...
            mvpalab_kaiserbeta(cfg));

        % Calculate the filter coefficients
        f = cfg.sf.fcutoff{i}/(cfg.sf.fs/2);
        cfg.sf.coeff = firws(cfg.sf.order,f,type,cfg.sf.win);

        % Plot frequency response:
        nfft = cfg.sf.fs * 10;
        
        impresp = cfg.sf.coeff(:)';
        n = length(impresp);

        nfft = max([2^ceil(log2(n)) nfft]);
        f = linspace(0, cfg.sf.fs / 2, nfft / 2 + 1);
        z = fft(impresp, nfft);
        z = z(1:nfft / 2 + 1);
        
        % Color gradient:
        shift = floor(limit/length(cfg.sf.fcutoff)) - 1;
        color = color + shift;
        index = limit - color;
        
        if index == 0
            index = 1;
        end
        
        
        % Plot magnitude response:
        plot(f, 20 * log10(abs(z)), 'LineWidth',1,...
            'Color', grd.neptune(index,:));
    end
    
    % Titles and axis:
    title('Magnitude response (linear spacing)');
    ylabel('Magnitude (dB)');
    xlabel('Frequency (Hz)');
    xlim([0,cfg.sf.hfreq]);

end

