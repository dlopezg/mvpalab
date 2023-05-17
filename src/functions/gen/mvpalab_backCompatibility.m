function cfg = mvpalab_backCompatibility(cfg)
    %% Envelope as feature:
    if ~isfield(cfg,'feature')
        cfg.feature = 'voltage';
        cfg.powenv.method   = 'analytic';
        cfg.powenv.uplow = 'upper';
        cfg.powenv.length   = 5;
        warning('CFG structure updated > Features');
    end
    
    %% Channels:
    % The cfg.chanloc variable has been moved to cfg.channels.chanloc
    if isfield(cfg,'chanloc')
        cfg.channels.selected = [];
        cfg.channels.chanloc = cfg.chanloc;
        cfg.channels.selectedchanloc = cfg.chanloc;
        cfg = rmfield(cfg,'chanloc');
        warning('CFG structure updated > Channels');
    end
end

