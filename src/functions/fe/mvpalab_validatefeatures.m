function mvpalab_validatefeatures(cfg)
%% MVPALAB_VALIDATEFEATURES
%
%  This function checks the settings of the feature extraction before the
%  import reads any file (see mvpalab_classfeatures), so a misspelled
%  value stops with a clear error instead of being taken as another one:
%
%  - cfg.feature is 'voltage' or 'envelope'.
%  - With the power envelope: cfg.powenv.method is 'analytic' or 'peak',
%    cfg.powenv.uplow is 'upper' or 'lower', and cfg.powenv.length is a
%    whole number of at least 1 (see mvpalab_powenvelope).
%  - cfg.smoothdata.method is 'none', 'moving' or 'gaussian', and with
%    smoothing cfg.smoothdata.window is a whole number of at least 1 (see
%    mvpalab_smoothdata).
%
%  mvpalab_validateimport calls it.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.feature, cfg.powenv and cfg.smoothdata).

oneof(cfg.feature,{'voltage','envelope'},'cfg.feature');

if strcmp(cfg.feature,'envelope')
    oneof(cfg.powenv.method,{'analytic','peak'},'cfg.powenv.method');
    oneof(cfg.powenv.uplow,{'upper','lower'},'cfg.powenv.uplow');
    whole(cfg.powenv.length,'cfg.powenv.length');
end

oneof(cfg.smoothdata.method,{'none','moving','gaussian'},'cfg.smoothdata.method');
if ~strcmp(cfg.smoothdata.method,'none')
    whole(cfg.smoothdata.window,'cfg.smoothdata.window');
end

end

function oneof(value,values,name)
%% Error if value is not one of values.

if ~any(strcmp(value,values))
    quoted = strcat('''',values,'''');
    error('mvpalab:validatefeatures',...
        '%s must be %s or %s.',name,strjoin(quoted(1:end-1),', '),quoted{end});
end

end

function whole(value,name)
%% Error if value is not a whole number of at least 1.

if ~isscalar(value) || value < 1 || value ~= round(value)
    error('mvpalab:validatefeatures',...
        '%s must be a whole number of at least 1.',name);
end

end
