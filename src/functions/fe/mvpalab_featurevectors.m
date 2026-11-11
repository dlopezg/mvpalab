function out_data = mvpalab_featurevectors(cfg,data)
%% MVPALAB_FEATUREVECTORS
%
%  This function generates the feature vectors of one subject from the
%  data of each class: the features of each class (see
%  mvpalab_classfeatures) and the data matrix and the labels (see
%  mvpalab_joinclasses). The feature vectors keep all the single trials:
%  the supertrials, the class sizes and cfg.normdata are applied in each
%  repetition of the analysis (see mvpalab_preparedata), so each analysis
%  uses its own settings. With supertrials (cfg.trialaver.flag) each class
%  needs at least cfg.trialaver.ntrials trials; otherwise it gives an
%  error.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {cell array} - data:
%    Data of the subject, one cell per dataset (see mvpalab_classdata).
%    Each cell is a structure with one field per class, named after
%    cfg.study.conditionIdentifier without spaces, with the data
%    [channels x timepoints x trials].
%
%%  OUTPUT:
%
%  - {struct} - out_data:
%    Data matrices (X) and categorical labels (Y), with the fields a and,
%    in MVCC, b (see mvpalab_joinclasses). X: [trials x channels x
%    timepoints]. With supertrials, also singletrials = true (see
%    mvpalab_checkfv).

%% Features of each class:
for dataset = 1 : numel(data)
    names = fieldnames(data{dataset});
    for condition = 1 : numel(names)
        fprintf('\n    <strong> - Generating feature vectors:</strong> ');
        fprintf([names{condition} '\n']);
        fv{dataset,condition} = mvpalab_classfeatures(cfg,data{dataset}.(names{condition}));
        if cfg.trialaver.flag && size(fv{dataset,condition},1) < cfg.trialaver.ntrials
            error('Class %s has fewer trials than cfg.trialaver.ntrials.',...
                names{condition});
        end
    end
end

%% Data and labels, with the classes named '1', '2'...:
sets = {'a','b'};
classes = cellstr(string(1:size(fv,2)));
for dataset = 1 : size(fv,1)
    joined = mvpalab_joinclasses(fv(dataset,:),classes);
    out_data.X.(sets{dataset}) = joined.X;
    out_data.Y.(sets{dataset}) = joined.Y;
end

%  mvpalab_checkfv needs to know that they are not supertrials:
out_data.singletrials = true;

fprintf('\n');

end
