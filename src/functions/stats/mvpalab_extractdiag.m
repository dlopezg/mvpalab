function [per,permaps,stats] = mvpalab_extractdiag(cfg,performance,permuted_maps)

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
