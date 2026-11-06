function repdata = mvpalab_repdata(cfg,data)
%% MVPALAB_REPDATA
%
%  This function returns the datasets of one repetition. With supertrials
%  (cfg.trialaver) it builds them from the single trials and then selects
%  the channels, so the normalization of each supertrial uses all the
%  channels, as the normalization of each single trial when the data is
%  imported. Without supertrials the datasets do not change.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - data:
%    Datasets of the subject (see mvpalab_loadfv).
%
%%  OUTPUT:
%
%  - {struct} - repdata:
%    Datasets of this repetition.

repdata = mvpalab_supertrials(cfg,data);

if cfg.trialaver.flag
    sets = fieldnames(repdata);
    for s = 1 : numel(sets)
        repdata.(sets{s}).X = mvpalab_chanselection(repdata.(sets{s}).X,cfg);
    end
end

end
