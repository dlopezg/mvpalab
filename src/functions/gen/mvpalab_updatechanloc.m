function cfg = mvpalab_updatechanloc(cfg,sel)
%% MVPALAB_UPDATECHANLOC
%
%  This function sets the locations of the selected channels
%  (cfg.channels.selectedchanloc) from the locations of all the channels
%  (cfg.channels.chanloc): all of them if the selection is empty, and
%  none if the data has no locations. The decoding and RSA analyses call
%  it when they start, and the GUI when the selection changes.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.channels).
%
%  - {matrix} - sel:
%    Indices of the selected channels.
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    The same structure with cfg.channels.selectedchanloc.

cfg.channels.selectedchanloc = cfg.channels.chanloc;

if ~isempty(sel) && ~isempty(cfg.channels.chanloc)
    cfg.channels.selectedchanloc = cfg.channels.chanloc(sel);
end

end
