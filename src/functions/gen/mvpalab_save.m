function mvpalab_save(cfg,data,mode)
%% MVPALAB_SAVE
%
%  This function saves a structure of results, permuted maps or statistics
%  in cfg.savefolder: each field is saved in a folder with its name, so the
%  folders follow the fields of the structure, and each leaf is a file with
%  the data and cfg. The statistics of one map (a structure with the field
%  sigmask) are one leaf.
%
%  cfg.savefolder is set by the analysis that computes the results, in
%  cfg.location/results/cfg.analysis (cfg.analysis is only the name that
%  separates the results of different runs, empty by default):
%  - Decoding (mvpalab_decoding): time_resolved or temporal_generalization
%    in that folder; mvpalab_extractdiag uses time_resolved.
%  - RSA (mvpalab_rsa_time, mvpalab_rsa_roi) and fusion (mvpalab_fusion):
%    the folder itself.
%  - Sliding filter (mvpalab_sfilter): diffMaps in that folder, where it
%    saves its own files.
%  A cfg returned by an analysis keeps its cfg.savefolder, so the
%  statistics of mvpalab_permtest go with the results.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - data:
%    Structure to save.
%
%  - {string} - mode:
%    'res' (result.mat, variable result), 'permaps' (permaps.mat, variable
%    permaps) or 'stats' (stats.mat, variable stats).

modes.res = struct('message','results','variable','result');
modes.permaps = struct('message','permuted maps','variable','permaps');
modes.stats = struct('message','stats','variable','stats');
if ~isfield(modes,mode)
    error('The mode of mvpalab_save must be ''res'', ''permaps'' or ''stats''.');
end
kind = modes.(mode);

if isempty(cfg.savefolder)
    error(['cfg.savefolder is set by the analysis. Use the cfg returned by ' ...
        'the analysis that computed the results.']);
end

fprintf(['<strong> > Saving ' kind.message ': </strong>']);
savefields(cfg,data,cfg.savefolder,kind);
fprintf(' - Done! \n\n');

end

function savefields(cfg,data,folder,kind)
%% Each field in a folder with its name, and each leaf in one file.

if isstruct(data) && ~isfield(data,'sigmask')
    for field = fieldnames(data)'
        savefields(cfg,data.(field{1}),fullfile(folder,field{1}),kind);
    end
    return
end

mvpalab_mkdir(folder);
content.(kind.variable) = data;
content.cfg = cfg;
save(fullfile(folder,[kind.variable '.mat']),'-struct','content','-v7.3');

end
