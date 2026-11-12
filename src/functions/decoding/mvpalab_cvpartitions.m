function part = mvpalab_cvpartitions(cfg,data,job)
%% MVPALAB_CVPARTITIONS
%
%  This function draws the cross-validation partitions of one repetition,
%  one per direction of the analysis (see mvpalab_dirpartition): the two
%  letters of each direction are the training and test datasets. All of
%  them are described in the same way, so the trials of each fold are
%  decided here. Leave-one-out in MVCC needs datasets of the same size.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.cv).
%
%  - {struct} - data:
%    Datasets of the repetition (see mvpalab_preparedata).
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

if job.mvcc && strcmp(cfg.cv.method,'loo') && length(data.a.Y) ~= length(data.b.Y)
    error('mvpalab:cvpartitions',...
        'MVCC with leave-one-out needs datasets of the same size.');
end

for d = 1 : numel(job.dirs)
    way = job.dirs{d};
    part.(way) = mvpalab_dirpartition(cfg,data.(way(1)).Y,data.(way(2)).Y,...
        way(1) == way(2));
end

end
