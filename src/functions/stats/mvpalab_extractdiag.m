function [per,permaps,stats] = mvpalab_extractdiag(cfg,performance,permuted_maps)
%% MVPALAB_EXTRACTDIAG
%
%  This function extracts the diagonal of the temporal generalization maps
%  (the same training and test timepoints) to obtain the time-resolved
%  results. It needs the same training and test time windows
%  (cfg.tm.tpoints and cfg.tm.tpoints_), and stops with an error
%  otherwise. Only the fields acc, auc, precision, recall and f1score at
%  the first level of performance are extracted, as in the results of
%  MVPA, without fields per direction.
%
%  The results are saved with mvpalab_save in the time_resolved folder.
%  With permuted maps, the permuted maps are saved too and the
%  permutation test is computed and saved (see mvpalab_permtest). Only
%  the metrics that have permuted maps are tested.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - performance:
%    Result structure of a temporal generalization analysis, with maps
%    [ntp x ntp x subjects x bands] in each metric (precision, recall and
%    f1score with one field per class, see mvpalab_storemap).
%
%  - {struct} - permuted_maps:
%    Optional. Permuted maps of a temporal generalization analysis, with
%    maps [ntp x ntp x subjects x maps x bands] in each metric.
%
%%  OUTPUT:
%
%  - {struct} - per:
%    Diagonal of each metric, with maps [1 x ntp x subjects x bands].
%
%  - {struct} - permaps:
%    Diagonal of the permuted maps, with maps
%    [1 x ntp x subjects x maps x bands]. Only with permuted_maps.
%
%  - {struct} - stats:
%    Statistics of the permutation test (see mvpalab_permtest). Only with
%    permuted_maps.

% Check cfg structure:
cfg = mvpalab_checkcfg(cfg);

% The diagonal needs the same training and test timepoints:
if ~isequal(cfg.tm.tpoints,cfg.tm.tpoints_)
    error('The diagonal needs the same training and test time windows.');
end

fprintf('<strong> > Extracting time resolved diagonal: </strong>');

cfg.classmodel.tempgen = false;
%% Loop over different performance metrics:
fields = fieldnames(performance);
validfields = {'acc' 'auc' 'precision' 'recall' 'f1score'};

% For each field:
for i = 1 : numel(fields)
    if find(strcmp(validfields, fields{i}))
        per.(fields{i}) = diagonal(performance.(fields{i}));
        % The sign flip test has no maps of the class metrics:
        if nargin > 2 && isfield(permuted_maps,fields{i})
            permaps.(fields{i}) = diagonal(permuted_maps.(fields{i}));
        end
    end
end

fprintf(' > Done! ');
fprintf('\n\n');

%% Permutations tests and save result:
mvpalab_save(cfg,per,'res');
if nargin > 2
    mvpalab_save(cfg,permaps,'permaps');
    stats = mvpalab_permtest(cfg,per,permaps);
end
end

function out = diagonal(map)
%% Diagonal of each subject and permuted map, in every field of a metric.

if isstruct(map)
    out = structfun(@diagonal,map,'UniformOutput',false);
    return
end

sz = size(map);
out = zeros([1 sz(2:end)],'like',map);
for k = 1 : prod(sz(3:end))
    out(1,:,k) = diag(map(:,:,k));
end

end
