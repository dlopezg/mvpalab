function [raw,cfg] = mvpalab_readsubject(cfg,sub)
%% MVPALAB_READSUBJECT
%
%  This function loads the files of one subject: one per class and
%  dataset (see mvpalab_loadfile). The first subject stores the
%  information of the study in cfg (see mvpalab_datainfo), and the files
%  of every subject are checked against it (see mvpalab_validatefiles).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {int} - sub:
%    Subject.
%
%%  OUTPUT:
%
%  - {cell array} - raw:
%    Data of each dataset and class {datasets x classes}, in the format of
%    mvpalab_dataformat. Dataset B only in MVCC.
%
%  - {struct} - cfg:
%    Configuration structure, updated by the first subject.

fprintf('\n');
fprintf('<strong> > Importing subject data </strong> - Subject: ');
fprintf([int2str(sub) '/' int2str(length(cfg.study.dataFiles{1,1}))]);
fprintf('\n');

nsets = 1 + mvpalab_ismvcc(cfg);
nclass = size(cfg.study.dataFiles,2);

raw = cell(nsets,nclass);
for dataset = 1 : nsets
    for condition = 1 : nclass
        raw{dataset,condition} = mvpalab_loadfile(cfg,dataset,condition,sub);
    end
end

if sub == 1, cfg = mvpalab_datainfo(cfg,raw); end
mvpalab_validatefiles(cfg,raw,sub);

end
