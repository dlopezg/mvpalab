function cfg = mvpalab_backCompatibility(cfg)
    %% Envelope as feature:
    if ~isfield(cfg.fext,'feature')
        cfg.fext.feature = 'voltage';
        cfg.fext.powenv.method   = 'analytic';
        cfg.fext.powenv.envelope = 'upper';
        cfg.fext.powenv.length   = 5;
    end
end

