function data = mvpalab_smoothdata(cfg,data)
%% MVPALAB_SMOOTHDATA
%
%  This function smooths each feature and trial of the data along the
%  timepoints, with the method cfg.smoothdata.method and the window
%  cfg.smoothdata.window. The method 'gaussian' uses the MATLAB function
%  smoothdata: if it is not available, the function shows a warning and
%  returns the data without smoothing. The method 'moving' is the moving
%  average of the MATLAB function smooth: an odd window (an even window
%  is reduced by one) that becomes smaller and stays centered at the
%  first and last timepoints.
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
    if exist('smoothdata','file')
        data = smoothdata(data,2,'gaussian',cfg.smoothdata.window);
    else
        warning('mvpalab:smoothdata','The gaussian kernel is not available.')
        warning('mvpalab:smoothdata','The smoothing step is not computed!')
    end
    return
end

width = cfg.smoothdata.window - 1 + mod(cfg.smoothdata.window,2);
ntp = size(data,2);
smoothed = movmean(data,width,2);
for edge = 1 : (width - 1)/2
    smoothed(:,edge,:) = mean(data(:,1:2*edge-1,:),2);
    smoothed(:,ntp-edge+1,:) = mean(data(:,ntp-2*edge+2:ntp,:),2);
end
data = smoothed;

end
