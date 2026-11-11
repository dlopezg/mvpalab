function mvcc = mvpalab_ismvcc(cfg)
%% MVPALAB_ISMVCC
%
%  This function says whether the decoding of a study is a
%  cross-classification (MVCC) or not (MVPA), from its files: it is MVCC
%  if every class of dataset B (the second row of cfg.study.dataFiles) has
%  its files, and MVPA if dataset B has no files. A dataset B with only
%  some of its classes gives an error in mvpalab_checkclasses.
%
%  cfg.analysis does not decide it: it is only the name of the results
%  (see mvpalab_save).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.study.dataFiles).
%
%%  OUTPUT:
%
%  - {logical} - mvcc:
%    True if the decoding is MVCC.

files = cfg.study.dataFiles;
mvcc = size(files,1) > 1 && all(~cellfun(@isempty,files(2,:)));

end
