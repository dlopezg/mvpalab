function cfg = mvpalab_updatechanloc(sel,cfg)
%% MVPALAB_UPDATECHANLOC
%
%  This function updates the chanloc structure imported from EEGlab data
%
%  INPUT:
%
%  - cfg: (STRUCT) Configuration estructure.
%
%  - sel: (INT VECTOR) Int vector containing the indexes of the selected
%         electrodes.
%
%  OUTPUT:
%
%  - cfg: (STRUCT) Updated chanloc structure.
%

if isempty(sel)
    cfg.channels.selectedchanloc = cfg.channels.chanloc;
else
    if ~isempty(cfg.channels.chanloc)
        cfg.channels.selectedchanloc = cfg.channels.chanloc(sel);
    end
end

end



