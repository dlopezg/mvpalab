function data = mvpalab_powenvelope(cfg,data)
%% MVPALAB_POWENVELOPE
%
%  This function replaces the data of each channel and trial with its
%  envelope (MATLAB function envelope), computed with the method in
%  cfg.powenv.method and the length in cfg.powenv.length. The upper
%  envelope is kept if cfg.powenv.uplow is 'upper' and the lower envelope
%  otherwise. It is used by mvpalab_classfeatures when cfg.feature = 'envelope'.
%
%  The envelope uses the whole epoch of each trial, so post-stimulus
%  information can reach the baseline (see mvpalab_init).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.powenv).
%
%  - {matrix} - data:
%    Data of one class [channels x timepoints x trials].
%
%%  OUTPUT:
%
%  - {matrix} - data:
%    Envelopes [channels x timepoints x trials].

fprintf('       # Computing power envelopes... ');
for trial = 1 : size(data,3)
    for channel = 1 : size(data,1)
        [env,env_] = envelope(data(channel,:,trial), ...
            cfg.powenv.length, cfg.powenv.method);
        if strcmp(cfg.powenv.uplow,'upper')
            data(channel,:,trial) = env;
        else
            data(channel,:,trial) = env_;
        end
    end
end
fprintf('Done.\n');

end
