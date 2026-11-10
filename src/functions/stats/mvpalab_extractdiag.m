function [per,nulldiag,stats] = mvpalab_extractdiag(cfg,performance,nullmaps)
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
%  With the maps of the null distribution, the permutation test is
%  computed and saved (see mvpalab_permtest), and the diagonal of the
%  permuted maps is saved too, but not that of the maps of the sign flip
%  test (cfg.stats.signflip), as in the analyses. Only the metrics that
%  have maps of the null distribution are tested.
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
%  - {struct} - nullmaps:
%    Optional. Maps of the null distribution of a temporal generalization
%    analysis (see mvpalab_nullmaps), with maps
%    [ntp x ntp x subjects x maps x bands] in each metric.
%
%%  OUTPUT:
%
%  - {struct} - per:
%    Diagonal of each metric, with maps [1 x ntp x subjects x bands].
%
%  - {struct} - nulldiag:
%    Diagonal of the maps of the null distribution, with maps
%    [1 x ntp x subjects x maps x bands]. Only with nullmaps.
%
%  - {struct} - stats:
%    Statistics of the permutation test (see mvpalab_permtest). Only with
%    nullmaps.

% Check cfg structure:
cfg = mvpalab_updatecfg(cfg);

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
        if nargin > 2 && isfield(nullmaps,fields{i})
            nulldiag.(fields{i}) = diagonal(nullmaps.(fields{i}));
        end
    end
end

fprintf(' > Done! ');
fprintf('\n\n');

%% Permutations tests and save result:
mvpalab_save(cfg,per,'res');
if nargin > 2
    if ~cfg.stats.signflip, mvpalab_save(cfg,nulldiag,'permaps'); end
    stats = mvpalab_permtest(cfg,per,nulldiag);
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
