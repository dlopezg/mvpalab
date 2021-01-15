function [cfg, data] = mvpalab_powenvelope(cfg, data)
    fprintf('       # Computing power envelopes... ');
    for trial = 1 : size(data,3)
        for channel = 1 : size(data,1)
            [env,env_] = envelope(data(channel,:,trial), ...
                cfg.fext.powenv.length, cfg.fext.powenv.method);
            if strcmp(cfg.fext.powenv.envelope,'upper')
                data(channel,:,trial) = env;
            else
                data(channel,:,trial) = env_;
            end
        end
    end
    fprintf('Done.\n');
end