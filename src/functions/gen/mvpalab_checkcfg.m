function cfg_ = mvpalab_checkcfg(cfg_,cfg)

% Initialize algorithm:
if nargin < 2
    cfg = mvpalab_init(false);
    
    % Change fields names if needed (possible code refactoring)
    cfg_ = mvpalab_backCompatibility(cfg_);
end

if isstruct(cfg)
    % If is a struct, extract fieldnames:
    subfields = fieldnames(cfg);
    
    % Check if each subfield exists inside the old cfg structure. If not,
    % add the new field to the old cfg structure and continue. If exists,
    % recursive call.
    for subfield = 1 : length(subfields)
        if isfield(cfg_,subfields{subfield})
            cfg_.(subfields{subfield}) = mvpalab_checkcfg(...
                cfg_.(subfields{subfield}),...
                cfg.(subfields{subfield}));
        else
            warning(['CFG structure updated > New field created: '...
                subfields{subfield}])
            cfg_.(subfields{subfield}) = cfg.(subfields{subfield});
        end
    end
end

% Save the new cfg structure
mvpalab_savecfg(cfg_);

end