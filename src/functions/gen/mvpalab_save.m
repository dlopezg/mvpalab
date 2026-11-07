function mvpalab_save(cfg,data,mode)
%% MVPALAB_SAVE
%
%  This function saves a structure of results, permuted maps or statistics
%  in cfg.location/results: each field is saved in a folder with its name,
%  so the folders follow the fields of the structure, and each leaf is a
%  file with the data and cfg. The statistics of one map (a structure with
%  the field sigmask) are one leaf.
%
%  The first folder is time_resolved or temporal_generalization in MVPA
%  and MVCC, and cfg.analysis in the other analyses.
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

fprintf(['<strong> > Saving ' kind.message ': </strong>']);
savefields(cfg,data,fullfile(cfg.location,'results',resultsfolder(cfg)),kind);
fprintf(' - Done! \n\n');

end

function folder = resultsfolder(cfg)
%% First folder of the results of the analysis.

folder = cfg.analysis;
if any(strcmp(cfg.analysis,{'MVPA','MVCC'}))
    folder = 'time_resolved';
    if cfg.classmodel.tempgen, folder = 'temporal_generalization'; end
end

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
