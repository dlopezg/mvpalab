function data = mvpalab_smoothdata(cfg, data)
    smoothfunction = exist('smoothdata');
    for feature = 1 : size(data,1)
        for trial = 1 : size(data,3)
            if strcmp(cfg.smoothdata.method,'gaussian')
                if smoothfunction
                    data(feature,:,trial) = smoothdata(...
                        data(feature,:,trial),2,'gaussian',...
                        cfg.smoothdata.window);
                else
                    warning('The gaussian kernel is not available.')
                    warning('The smoothing step is not computed!')
                    return
                end
            else
                data(feature,:,trial) = smooth(data(feature,:,trial),...
                cfg.smoothdata.window, cfg.smoothdata.method);
            end
        end
    end
end

