function part = mvpalab_mvccpartition(cfg,Y,Yt)
%% MVPALAB_MVCCPARTITION
%
%  This function generates the cross-validation partitions of the
%  training and test datasets of a cross-classification analysis (MVCC).
%
%  The partitions are generated once per cross-validation repetition,
%  before the timepoints loop, and the same partitions are used at all the
%  timepoints (as in MVPA, see mvpalab_decodemap). If a new
%  partition is drawn at each timepoint, each timepoint is evaluated with
%  different training and test trials and the result at each timepoint
%  gets independent cross-validation noise.
%
%  The cross-validation of MVCC does not separate training and test trials,
%  because they belong to different datasets. Each fold trains and tests
%  with the training trials of a partition of each dataset.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure (cfg.cv.method and cfg.cv.nfolds).
%
%  - {1D-array} - Y:
%    Labels of the training dataset.
%
%  - {1D-array} - Yt:
%    Labels of the test dataset.
%
%%  OUTPUT:
%
%  - {struct} - part:
%    Logical matrices [trials x folds] with the trials of the training
%    dataset (part.train) and the test dataset (part.test) of each fold.
%    Without cross-validation (cfg.cv.method = 'none') there is one fold
%    with all the trials.

if strcmp(cfg.cv.method,'none')
    part.train = true(length(Y),1);
    part.test = true(length(Yt),1);
else
    if strcmp(cfg.cv.method,'loo') && length(Y) ~= length(Yt)
        error('MVCC with leave-one-out needs datasets of the same size.');
    end
    part.train = mvpalab_trainfolds(cfg,Y);
    part.test = mvpalab_trainfolds(cfg,Yt);
end

end
