function out = mvpalab_meanreps(reps)
%MVPALAB_MEANREPS Average a metric container across CV repetitions.
%
%   out = mvpalab_meanreps(reps)
%
%   reps is a 1 x nreps cell array where every element holds the same metric
%   container produced by a single cross-validation repetition. Each element
%   can be:
%       - A numeric array (time-resolved case: e.g. a confusion matrix or a
%         per-class precision/recall/f1 vector).
%       - A cell array (temporal generalization case: a container indexed by
%         test timepoint, whose elements are numeric).
%       - An empty cell {} (metric disabled), in which case {} is returned to
%         preserve the current behaviour.
%
%   The function averages the contents element-wise across repetitions,
%   recursing into nested cells so it handles both the time-resolved and the
%   temporal generalization layouts transparently.

first = reps{1};

if iscell(first)
    % Temporal generalization (or disabled metric -> empty cell):
    out = cell(size(first));
    for i = 1 : numel(first)
        tmp = cellfun(@(r) r{i},reps,'UniformOutput',false);
        out{i} = mvpalab_meanreps(tmp);
    end
else
    % Time-resolved numeric container:
    acc = first;
    for r = 2 : numel(reps)
        acc = acc + reps{r};
    end
    out = acc / numel(reps);
end

end
