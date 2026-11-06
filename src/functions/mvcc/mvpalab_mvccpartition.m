function [strpar,strpart] = mvpalab_mvccpartition(cfg,Y,Yt)
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
%  - {cvpartition/struct} - strpar:
%    Stratified partition of the training dataset.
%
%  - {cvpartition/struct} - strpart:
%    Stratified partition of the test dataset.
%
%    Without cross-validation (cfg.cv.method = 'none') both are structures
%    with the fields NumTestSets = 1 and NumObservations.

if strcmp(cfg.cv.method,'none')
    strpar.NumTestSets = 1;
    strpar.NumObservations = length(Y);
    strpart.NumTestSets = 1;
    strpart.NumObservations = length(Yt);
else
    if strcmp(cfg.cv.method,'loo') && length(Y) ~= length(Yt)
        error('MVCC with leave-one-out needs datasets of the same size.');
    end
    strpar  = cvpartition(Y,'KFold',cfg.cv.nfolds);  % Train
    strpart = cvpartition(Yt,'KFold',cfg.cv.nfolds); % Test
end

end
