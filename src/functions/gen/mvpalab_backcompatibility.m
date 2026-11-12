function cfg = mvpalab_backcompatibility(cfg)
%% MVPALAB_BACKCOMPATIBILITY
%
%  This function updates the renamed fields of a configuration structure of
%  an older version of MVPAlab, with a warning:
%
%  - The field cfg.chanloc is moved to cfg.channels.chanloc and
%    cfg.channels.selectedchanloc, with cfg.channels.selected empty.
%  - cfg.analysis = 'MVPA' or 'MVCC' of a structure without cfg.gui (made
%    before cfg.analysis became only the name of the results) is moved to
%    cfg.gui.type, and cfg.analysis is left empty, so the results keep
%    their folders. MVPA or MVCC is decided by the files (see
%    mvpalab_ismvcc).
%
%  The missing fields are added by mvpalab_updatecfg.
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
        warning('mvpalab:backcompatibility','CFG structure updated > Channels');
    end

    %% Analysis type:
    % cfg.analysis is only the name of the results:
    if ~isfield(cfg,'gui') && isfield(cfg,'analysis') && ...
            any(strcmp(cfg.analysis,{'MVPA','MVCC'}))
        cfg.gui.type = cfg.analysis;
        cfg.analysis = '';
        warning('mvpalab:backcompatibility',...
            'CFG structure updated > cfg.analysis moved to cfg.gui.type');
    end
end

