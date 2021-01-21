function cfg = mvpalab_backCompatibility(cfg)
    %% Envelope as feature:
    if ~isfield(cfg,'feature')
        cfg.feature = 'voltage';
        cfg.powenv.method   = 'analytic';
        cfg.powenv.uplow = 'upper';
        cfg.powenv.length   = 5;
    end
end

