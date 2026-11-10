function part = mvpalab_dirpartition(cfg,Y,Yt,same)
%% MVPALAB_DIRPARTITION
%
%  This function draws the cross-validation partition of one direction of
%  the analysis, from its training labels (Y) and its test labels (Yt):
%
%  - Within one dataset (MVPA), one partition (see mvpalab_foldmasks): the
%    test trials of each fold are the trials out of its training trials.
%  - Across datasets (MVCC), one partition of each dataset, drawn on their
%    own, because their trials are different: each fold trains with the
%    trials of the mask of the training dataset and tests with those of
%    the mask of the test dataset. Without cross-validation
%    (cfg.cv.method = 'none') there is one fold with all the trials.
%
%  The partitions are drawn once per cross-validation repetition, before
%  the timepoints loop, and the same partitions are used at all the
%  timepoints (see mvpalab_evalmap). A partition drawn at each timepoint
%  would give each timepoint independent cross-validation noise.
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
%  - {logical} - same:
%    True if the training and test datasets are the same one.
%
%%  OUTPUT:
%
%  - {struct} - part:
%    Logical matrices [trials x folds] with the trials of the training
%    dataset (part.train) and the test dataset (part.test) of each fold.

if same
    part.train = mvpalab_foldmasks(cfg,Y);
    part.test = ~part.train;
elseif strcmp(cfg.cv.method,'none')
    part.train = true(length(Y),1);
    part.test = true(length(Yt),1);
else
    part.train = mvpalab_foldmasks(cfg,Y);
    part.test = mvpalab_foldmasks(cfg,Yt);
end

end
