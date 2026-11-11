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
%  - cfg.study.conditionIdentifier has a name for each class (column of
%    cfg.study.dataFiles) of every dataset that is read.
%  - Each class needs its own name, because two classes with the same name
%    share a field in mvpalab_import and one of them is lost without any
%    error.
%  - The names, without spaces, are valid field names (for example
%    'face_1', not 'face-1'), because the data of each class is stored in a
%    field with its name (see mvpalab_classdata).
%  - No class is named 'mean': the precision, recall and F1-score keep one
%    map per class and one with the mean of the classes, named 'mean' (see
%    mvpalab_decodingjob).
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

nsets = 1 + mvpalab_ismvcc(cfg);
if any(size(cfg.study.conditionIdentifier) < [nsets nclass])
    error(['cfg.study.conditionIdentifier needs a name for each class ' ...
        '(%d) of each dataset (%d).'],nclass,nsets);
end

for dataset = 1 : nsets
    ids = cfg.study.conditionIdentifier(dataset,1:nclass);
    ids = cellfun(@(id) id(~isspace(id)),ids,'UniformOutput',false);
    if numel(unique(ids)) < nclass
        error('The names in cfg.study.conditionIdentifier must be different.');
    end
    invalid = find(~cellfun(@isvarname,ids) | strcmp(ids,'mean'),1);
    if ~isempty(invalid)
        error(['The class name ''%s'' cannot be used: it must be a valid ' ...
            'field name other than ''mean''.'],ids{invalid});
    end
end

end
