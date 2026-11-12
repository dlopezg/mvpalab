function trdms = mvpalab_gentrdms(cfg,mdls,labels)
%% MVPALAB_GENTRDMS
%
%  This function returns theoretical RDMs according to the previously
%  constructed model. For condition-wise RDMs the models are already
%  specified. For trial-wise RDMs each model is expanded from conditions
%  to trials using the condition of each trial, so the trials can be in
%  any order. Row i of a model is the i-th condition of unique(labels), the
%  same order as the condition-wise RDMs (see mvpalab_averagetrials).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.rsa.trialwise).
%
%  - {cell array} - mdls:
%    Theoretical models (cfg.rsa.tmodels), one structure per model:
%    - id:  Identifier of the model.
%    - mdl: RDM of the model [conditions x conditions].
%
%  - {categorical} - labels (optional):
%    Only for trial-wise RDMs. Condition of each trial, in the
%    order of the rows of the neural RDM [trials x 1].
%
%%  OUTPUT:
%
%  - {matrix} - trdms:
%    Theoretical RDMs [trials x trials x 1 x models] or
%    [conditions x conditions x 1 x models].

fprintf('   - Computing theoretical RDMs:\n');

%% Analysis type:
%  If the analysis is computed condition-by-condition is not necessary to
%  generate the theoretical models because they are already specified:

if ~cfg.rsa.trialwise || nargin < 3
    for i = 1 : length(mdls)
        trdms(:,:,1,i) = mdls{i}.mdl;
    end
    return
end

%% Condition of each trial:
%  Index of the condition of each trial in unique(labels).

[~,~,cond] = unique(labels);

%% Theoretical models loop
%  Generate different RDMs for each theoretical model:

for i = 1 : length(mdls)
    %% Generate RDM:
    %  Each cell of the neural RDM is a pair of trials, and takes the value
    %  of the model for the conditions of these trials.

    fprintf(['      # Model: ' mdls{i}.id '... ']);

    trdms(:,:,1,i) = mdls{i}.mdl(cond,cond);

    fprintf('- Done.\n');
end

end
