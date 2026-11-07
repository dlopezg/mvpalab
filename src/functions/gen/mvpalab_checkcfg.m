function cfg = mvpalab_checkcfg(cfg)
%% MVPALAB_CHECKCFG
%
%  This function completes a configuration structure with the fields of the
%  current version of the toolbox (see mvpalab_init): each field that is
%  missing gets its default value, with a warning that names it, and the
%  structures that exist are completed in the same way. A field of the
%  user that is not a structure is kept as it is. The renamed fields of
%  older versions are updated first (see mvpalab_backCompatibility).
%
%  cfg.version is set to the version that runs the analysis, so the saved
%  results say which version computed them. It does not save the
%  structure (see mvpalab_savecfg): each analysis does it when it starts.
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

cfg = mvpalab_backCompatibility(cfg);
cfg = complete(cfg,mvpalab_init(false,false),'cfg');
cfg.version = mvpalab_getversion();

end

function cfg = complete(cfg,defaults,path)
%% Missing fields of one structure, and its structures completed in turn.

for field = fieldnames(defaults)'
    name = field{1};
    if ~isfield(cfg,name)
        warning('CFG structure updated > New field created: %s.%s',path,name);
        cfg.(name) = defaults.(name);
    elseif isstruct(cfg.(name)) && isstruct(defaults.(name))
        cfg.(name) = complete(cfg.(name),defaults.(name),[path '.' name]);
    end
end

end
