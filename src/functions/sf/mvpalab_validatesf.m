function mvpalab_validatesf(cfg)
%% MVPALAB_VALIDATESF
%
%  This function checks the settings of a sliding filter analysis before
%  the import removes the filtered data of a previous analysis (see
%  mvpalab_sffolders), because pop_firws of EEGLAB would only reject them
%  when it filters the first subject, and again when mvpalab_sfilter
%  starts, because cfg.sf.metric is only used there:
%
%  - cfg.sf.ftype is 'bandstop' or 'bandpass'. Each band has two cutoff
%    frequencies (see mvpalab_genfreqvec), so the 'lowpass' and
%    'highpass' filters of pop_firws, which need one, are not available.
%  - cfg.sf.wtype is 'rectangular', 'hann', 'hamming', 'blackman' or
%    'kaiser' (with the beta of mvpalab_kaiserbeta).
%  - cfg.sf.order is a positive even integer, as pop_firws needs.
%  - 0 <= cfg.sf.lfreq < cfg.sf.hfreq.
%  - cfg.sf.fspac is 'lin' or 'log' (see mvpalab_genfreqvec).
%  - cfg.sf.metric is 'acc' (accuracy) or 'auc' (area under the ROC
%    curve), the metric of the diffMaps.
%
%  The upper limit of the bands is not checked against the Nyquist
%  frequency here, because the sampling rate is only known when the first
%  file is read.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.sf).

if ~any(strcmp(cfg.sf.ftype,{'bandstop','bandpass'}))
    error('cfg.sf.ftype must be ''bandstop'' or ''bandpass''.');
end

wtypes = {'rectangular','hann','hamming','blackman','kaiser'};
if ~any(strcmp(cfg.sf.wtype,wtypes))
    error('cfg.sf.wtype must be %s.',strjoin(strcat('''',wtypes,''''),', '));
end

order = cfg.sf.order;
if ~isscalar(order) || order <= 0 || mod(order,2) ~= 0
    error('cfg.sf.order must be a positive even integer.');
end

if ~(cfg.sf.lfreq >= 0 && cfg.sf.lfreq < cfg.sf.hfreq)
    error('The limits of the bands must be 0 <= cfg.sf.lfreq < cfg.sf.hfreq.');
end

if ~any(strcmp(cfg.sf.fspac,{'lin','log'}))
    error('cfg.sf.fspac must be ''lin'' or ''log''.');
end

if ~any(strcmp(cfg.sf.metric,{'acc','auc'}))
    error('cfg.sf.metric must be ''acc'' or ''auc''.');
end

end
