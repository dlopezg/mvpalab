function data = mvpalab_smoothdata(cfg, data)
%% MVPALAB_SMOOTHDATA
%
%  This function smooths each feature and trial of the data along the
%  timepoints, with the method cfg.smoothdata.method and the window
%  cfg.smoothdata.window. The method 'gaussian' uses the MATLAB function
%  smoothdata: if it is not available, the function shows a warning and
%  returns the data without smoothing. The other methods use the MATLAB
%  function smooth.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.smoothdata).
%
%  - {matrix} - data:
%    Data [features x timepoints x trials].
%
%%  OUTPUT:
%
%  - {matrix} - data:
%    Smoothed data [features x timepoints x trials].

if strcmp(cfg.smoothdata.method,'gaussian')
    if exist('smoothdata')
        data = smoothdata(data,2,'gaussian',cfg.smoothdata.window);
    else
        warning('The gaussian kernel is not available.')
        warning('The smoothing step is not computed!')
    end
    return
end

for feature = 1 : size(data,1)
    for trial = 1 : size(data,3)
        data(feature,:,trial) = smooth(data(feature,:,trial),...
            cfg.smoothdata.window, cfg.smoothdata.method);
    end
end

end
