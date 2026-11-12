function data = mvpalab_normtrials(cfg,data)
%% MVPALAB_NORMTRIALS
%
%  This function normalizes each observation (trial or supertrial) of the
%  datasets, as set in cfg.normdata:
%
%  - 0: The data does not change.
%  - 1: Each observation is z-scored across features, at each timepoint.
%  - 2: Each observation is z-scored across time, for each feature.
%  - 3 and 4: The data does not change here. Each feature is z-scored in
%    each cross-validation fold with the training set (see
%    mvpalab_preparetrain), so these values are only used by the
%    classifiers.
%
%  Each observation is normalized on its own, so the result does not
%  depend on the other observations or on the class sizes. It is applied
%  to the data of each repetition, after the supertrials and before the
%  channel selection (see mvpalab_preparedata).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.normdata).
%
%  - {struct} - data:
%    Data matrix (X) and labels (Y) of dataset A (data.a) and, in MVCC, of
%    dataset B (data.b). X: [observations x channels x timepoints].
%
%%  OUTPUT:
%
%  - {struct} - data:
%    The same structure with the normalized data matrices.

switch cfg.normdata
    case 1
        dim = 2;    % features
    case 2
        dim = 3;    % time
    otherwise
        return
end

sets = fieldnames(data);
for dataset = 1 : numel(sets)
    data.(sets{dataset}).X = zscore(data.(sets{dataset}).X,[],dim);
end

end
