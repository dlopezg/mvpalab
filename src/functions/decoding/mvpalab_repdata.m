function repdata = mvpalab_repdata(cfg,data)
%% MVPALAB_REPDATA
%
%  This function returns the datasets of one repetition: the supertrials,
%  if enabled (see mvpalab_supertrials), with the selected channels (see
%  mvpalab_chanselection). The channels are selected after the
%  supertrials, so the normalization of each supertrial uses all the
%  channels, as the normalization of each single trial when the data is
%  imported.
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

sets = fieldnames(repdata);
for s = 1 : numel(sets)
    repdata.(sets{s}).X = mvpalab_chanselection(repdata.(sets{s}).X,cfg);
end

end
