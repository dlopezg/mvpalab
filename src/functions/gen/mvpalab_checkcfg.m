function cfg_ = mvpalab_checkcfg(cfg_,cfg)
%% MVPALAB_CHECKCFG
%
%  This function completes a configuration structure with the fields of the
%  current version of the toolbox. It does not save the structure (see
%  mvpalab_savecfg): each analysis does it when it starts.
%
%%  INPUT:
%
%  - {struct} - cfg_:
%    Configuration structure.
%
%  - {struct} - cfg:
%    Only in the recursive calls, default values of the current field.
%
%%  OUTPUT:
%
%  - {struct} - cfg_:
%    Updated configuration structure.

% Initialize algorithm:
if nargin < 2
    cfg = mvpalab_init(false,false);
    
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

end