function data = mvpalab_smoothdata(cfg, data)
    for feature = 1 : size(data,1)
        for trial = 1 : size(data,3)
            data(feature,:,trial) = smooth(data(feature,:,trial),...
                cfg.smoothdata.window, cfg.smoothdata.method);
        end
    end
end

