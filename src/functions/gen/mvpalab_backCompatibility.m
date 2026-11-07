function cfg = mvpalab_backCompatibility(cfg)
%% MVPALAB_BACKCOMPATIBILITY
%
%  This function updates a configuration structure of an older version of
%  MVPAlab, and shows a warning for each change:
%
%  - Without cfg.feature, it adds cfg.feature = 'voltage' and the default
%    values of cfg.powenv.
%  - The field cfg.chanloc is moved to cfg.channels.chanloc and
%    cfg.channels.selectedchanloc, with cfg.channels.selected empty.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure.

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

