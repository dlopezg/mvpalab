function data = mvpalab_preparedata(cfg,data,nfolds)
%% MVPALAB_PREPAREDATA
%
%  This function prepares the datasets of one repetition, in this order:
%
%  1. Supertrials (cfg.trialaver, see mvpalab_supertrials).
%  2. Class sizes (cfg.classsize, see mvpalab_trimclasses), with the folds
%     of the analysis.
%  3. Normalization of each observation (cfg.normdata = 1 or 2, see
%     mvpalab_normtrials).
%  4. Channel selection (cfg.channels.selected, see mvpalab_chanselection).
%
%  The decoding analyses call it once per cross-validation repetition (see
%  mvpalab_evalmap) and RSA once per subject (see mvpalab_rsa_time). The
%  channels are selected after the normalization, so cfg.normdata = 1
%  z-scores each observation across all the channels.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - data:
%    Single trials (X) and labels (Y) of dataset A (data.a) and, in MVCC,
%    of dataset B (data.b). X: [trials x channels x timepoints].
%
%  - {int} - nfolds:
%    Number of folds of cfg.classsize.matchkfold: cfg.cv.nfolds in the
%    decoding (see mvpalab_decodingjob) or cfg.rsa.nfolds in RSA.
%
%%  OUTPUT:
%
%  - {struct} - data:
%    Datasets of this repetition.

%% Supertrials and class sizes:
data = mvpalab_supertrials(cfg,data);
data = mvpalab_trimclasses(cfg,data,nfolds);

%% Normalization of each observation:
data = mvpalab_normtrials(cfg,data);

%% Selected channels:
sets = fieldnames(data);
for s = 1 : numel(sets)
    data.(sets{s}).X = mvpalab_chanselection(data.(sets{s}).X,cfg);
end

end
