function [cfg, data, fv] = mvpalab_readdata(cfg)
%% MVPALAB_READDATA
%
%  This function reads the data of each subject (see mvpalab_readsubject)
%  and computes its feature vectors (see mvpalab_featurevectors), without
%  filtering or saving anything. mvpalab_import calls it, and
%  mvpalab_sfilter also calls it to read the unfiltered baseline of a
%  sliding filter analysis.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (see mvpalab_preparestudy).
%
%%  OUTPUT:
%
%  - {struct} - cfg:
%    Updated configuration structure.
%
%  - {cell array} - data:
%    Data of each subject and dataset {subjects x datasets} (see
%    mvpalab_classdata).
%
%  - {cell array} - fv:
%    Feature vectors of each subject {1 x subjects} (see
%    mvpalab_featurevectors).

nsub = length(cfg.study.dataFiles{1,1});
data = cell(nsub,1 + strcmp(cfg.analysis,'MVCC'));
fv = cell(1,nsub);

for sub = 1 : nsub
    [raw,cfg] = mvpalab_readsubject(cfg,sub);
    data(sub,:) = mvpalab_classdata(cfg,raw);
    fv{sub} = mvpalab_featurevectors(cfg,data(sub,:));
end

end
