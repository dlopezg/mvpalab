function data = mvpalab_classfeatures(cfg,data)
%% MVPALAB_CLASSFEATURES
%
%  This function computes the features of one class: the power envelope if
%  cfg.feature = 'envelope' (see mvpalab_powenvelope) and the smoothing
%  with the method in cfg.smoothdata.method (see mvpalab_smoothdata),
%  unless it is 'none'. It returns them with the trials in the first
%  dimension.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.feature, cfg.powenv and cfg.smoothdata).
%
%  - {matrix} - data:
%    Data of one class [channels x timepoints x trials].
%
%%  OUTPUT:
%
%  - {matrix} - data:
%    Features of the class [trials x channels x timepoints].

%% Power envelope as a feature if needed:
if strcmp(cfg.feature,'envelope')
    data = mvpalab_powenvelope(cfg,data);
end

%% Smooth data:
if ~strcmp(cfg.smoothdata.method,'none')
    fprintf('       # Smoothing the data... ');
    data = mvpalab_smoothdata(cfg,data);
    fprintf('Done.\n');
end

%% Generate input vectors:
data = permute(data,[3 1 2]);

end
