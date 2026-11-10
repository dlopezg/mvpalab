function data = mvpalab_supertrials(cfg,data)
%% MVPALAB_SUPERTRIALS
%
%  This function builds the supertrials of a subject if cfg.trialaver.flag
%  is enabled. Otherwise, the datasets do not change.
%
%  The trials of each class are grouped in blocks of cfg.trialaver.ntrials
%  (cfg.trialaver.order: random or consecutive trials) and each block is
%  averaged. The remaining trials are not used. Then, the class sizes are
%  applied to the supertrials (see mvpalab_trimclasses).
%
%  The classes are defined by the labels of the datasets, so a permuted map
%  averages trials of the same permuted class (see mvpalab_permlabels).
%
%  It is called once per cross-validation repetition in the decoding
%  analyses, so the result does not depend on one draw of the blocks, and
%  once per subject in RSA (see mvpalab_preparedata).
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
%%  OUTPUT:
%
%  - {struct} - data:
%    The same structure with the supertrials and their labels.

if ~cfg.trialaver.flag, return; end

sets = fieldnames(data);

%% Average the trials of each class:
for dataset = 1 : numel(sets)
    [trials,classes{dataset}] = mvpalab_splitclasses(data.(sets{dataset}));
    for condition = 1 : numel(trials)
        fv{dataset,condition} = averageclass(cfg,trials{condition});
    end
end

%% Class sizes:
fv = mvpalab_trimclasses(cfg,fv);

%% Data and labels, with the names of the classes:
for dataset = 1 : numel(sets)
    data.(sets{dataset}) = mvpalab_joinclasses(fv(dataset,:),classes{dataset});
end

end

function super = averageclass(cfg,trials)
%% Supertrials of one class: [supertrials x channels x timepoints].

ntrials = cfg.trialaver.ntrials;
nsuper = floor(size(trials,1)/ntrials);

order = 1 : size(trials,1);
if strcmp(cfg.trialaver.order,'rand')
    order = randperm(size(trials,1));
end

super = zeros(nsuper,size(trials,2),size(trials,3));
for i = 1 : nsuper
    block = order((i-1)*ntrials + (1:ntrials));
    super(i,:,:) = mean(trials(block,:,:),1);
end

end
