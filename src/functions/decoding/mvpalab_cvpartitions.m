function part = mvpalab_cvpartitions(cfg,data,job)
%% MVPALAB_CVPARTITIONS
%
%  This function draws the cross-validation partitions of one repetition:
%  one partition in MVPA and, in MVCC, one partition of each dataset per
%  direction (see mvpalab_mvccpartition). All of them are described in the
%  same way, so the trials of each fold are decided here.
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
%    Partition of each direction (part.aa in MVPA, or part.ab and part.ba
%    in MVCC), with logical matrices [trials x folds] of the training
%    (train) and test (test) trials of each fold.

if job.mvcc
    part.ab = mvpalab_mvccpartition(cfg,data.a.Y,data.b.Y);
    part.ba = mvpalab_mvccpartition(cfg,data.b.Y,data.a.Y);
else
    part.aa.train = mvpalab_trainfolds(cfg,data.a.Y);
    part.aa.test = ~part.aa.train;
end

end
