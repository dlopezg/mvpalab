function mvpalab_checkclasses(cfg)
%% MVPALAB_CHECKCLASSES
%
%  This function checks the classes of the study, so the import or an
%  analysis stops before it starts:
%
%  - Dataset B (the second row of cfg.study.dataFiles) has the files of
%    every class or of none. With all of them the decoding is MVCC, and
%    without any of them it is MVPA (see mvpalab_ismvcc), so a dataset B
%    with only some classes would be ignored without any error.
%  - Each class needs its own name in cfg.study.conditionIdentifier, in
%    every dataset that is read, because two classes with the same name
%    share a field in mvpalab_import and one of them is lost without any
%    error.
%
%  mvpalab_checkimport and mvpalab_checkdecoding call it. The metrics that
%  need two classes are checked by mvpalab_checkdecoding.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.study).

nclass = size(cfg.study.dataFiles,2);

filled = ~cellfun(@isempty,cfg.study.dataFiles(2,:));
if any(filled) && ~all(filled)
    error('Dataset B needs the files of every class of dataset A, or of none.');
end

for dataset = 1 : 1 + mvpalab_ismvcc(cfg)
    ids = cfg.study.conditionIdentifier(dataset,1:nclass);
    ids = cellfun(@(id) id(~isspace(id)),ids,'UniformOutput',false);
    if numel(unique(ids)) < nclass
        error('The names in cfg.study.conditionIdentifier must be different.');
    end
end

end
