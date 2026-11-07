function [ data ] = mvpalab_preproc( cfg, data )
%% MVPALAB_PREPROC
%
%  This function smooths the data of one class with the method in
%  cfg.smoothdata.method (see mvpalab_smoothdata), unless it is 'none',
%  and returns it with the trials in the first dimension.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.smoothdata).
%
%  - {matrix} - data:
%    Data of one class [channels x timepoints x trials].
%
%%  OUTPUT:
%
%  - {matrix} - data:
%    Data of the class [trials x channels x timepoints].

%% Smooth data:
if ~strcmp(cfg.smoothdata.method,'none')
    fprintf('       # Smoothing the data... ');
    data = mvpalab_smoothdata(cfg,data);
    fprintf('Done.\n');
end

%% Generate input vectors:
data = permute(data,[3 1 2]);
fprintf('       # Done.\n');

end

