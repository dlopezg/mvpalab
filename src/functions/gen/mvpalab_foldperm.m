function pidx = mvpalab_foldperm(strpar)
%% MVPALAB_FOLDPERM
%
%  This function draws one permutation of the training labels for each
%  cross-validation fold, used to compute the permuted maps (MVPA and
%  MVCC) of the cluster-based permutation test.
%
%  The permutation is drawn once per fold, before the timepoints loop, and
%  the same permutation is applied to all the timepoints (and to all the
%  training timepoints of a temporal generalization matrix). If the labels
%  are shuffled again at each timepoint, the permuted maps are temporally
%  independent (white noise), the null clusters are too small and the
%  cluster-based permutation test is liberal. With a single permutation
%  across time the permuted maps keep the temporal structure of the data,
%  as required for a valid cluster-based permutation test (Maris &
%  Oostenveld, 2007; Stelzer, Chen & Turner, 2013).
%
%%  REFERENCES:
%
%  - Maris, E., & Oostenveld, R. (2007). Nonparametric statistical testing
%    of EEG- and MEG-data. Journal of Neuroscience Methods, 164(1),
%    177-190. https://doi.org/10.1016/j.jneumeth.2007.03.024
%
%  - Stelzer, J., Chen, Y., & Turner, R. (2013). Statistical inference and
%    multiple testing correction in classification-based multi-voxel
%    pattern analysis (MVPA): random permutations and cluster size
%    control. NeuroImage, 65, 69-82.
%    https://doi.org/10.1016/j.neuroimage.2012.09.063
%
%%  INPUT:
%
%  - {cvpartition/struct} - strpar:
%    Cross-validation partition of the training dataset. Without
%    cross-validation (MVCC, cfg.cv.method = 'none') a structure with the
%    fields NumTestSets = 1 and NumObservations.
%
%%  OUTPUT:
%
%  - {cell} - pidx:
%    Permutation of the training labels of each fold:
%    train_Y = train_Y(pidx{k}). [1 x folds]

pidx = cell(1,strpar.NumTestSets);

for k = 1 : strpar.NumTestSets
    if isa(strpar,'cvpartition')
        pidx{k} = randperm(sum(strpar.training(k)));
    else
        pidx{k} = randperm(strpar.NumObservations);
    end
end

end
