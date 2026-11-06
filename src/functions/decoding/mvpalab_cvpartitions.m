function part = mvpalab_cvpartitions(cfg,data,job)
%% MVPALAB_CVPARTITIONS
%
%  This function draws the cross-validation partitions of one repetition:
%  one partition in MVPA and, in MVCC, one partition of each dataset per
%  direction (see mvpalab_mvccpartition).
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.cv).
%
%  - {struct} - data:
%    Datasets of the subject (see mvpalab_loadfv).
%
%  - {struct} - job:
%    Description of the analysis (see mvpalab_decodingjob).
%
%%  OUTPUT:
%
%  - {struct} - part:
%    Partition of each direction: part.aa in MVPA, or the training and test
%    partitions part.ab.train, part.ab.test, part.ba.train and part.ba.test
%    in MVCC.

if job.mvcc
    [part.ab.train,part.ab.test] = mvpalab_mvccpartition(cfg,data.a.Y,data.b.Y);
    [part.ba.train,part.ba.test] = mvpalab_mvccpartition(cfg,data.b.Y,data.a.Y);
else
    part.aa = cvpartition(data.a.Y,'KFold',cfg.cv.nfolds);
end

end
