function cfg = mvpalab_backCompatibility(cfg)
%% MVPALAB_BACKCOMPATIBILITY
%
%  This function updates the renamed fields of a configuration structure of
%  an older version of MVPAlab, with a warning: the field cfg.chanloc is
%  moved to cfg.channels.chanloc and cfg.channels.selectedchanloc, with
%  cfg.channels.selected empty. The missing fields are added by
%  mvpalab_checkcfg.
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

