function Yp = mvpalab_permlabels(Y)
%% MVPALAB_PERMLABELS
%
%  This function returns a random reassignment of the labels of a dataset,
%  used to compute the permuted maps (MVPA and MVCC) of the cluster-based
%  permutation test.
%
%  A permuted map is the observed analysis repeated with labels that have
%  no relation with the data, so the labels are drawn once per permuted
%  map, before the cross-validation, and used as the labels of the dataset:
%  in the training and test sets of all the folds, repetitions and
%  timepoints. The observed result averages folds and repetitions with the
%  same labels, which removes the noise of the partition but not the noise
%  of the sample. If the labels are permuted again in each fold or
%  repetition, the permuted map also averages out the noise of the sample,
%  the null distribution is too narrow and the test is liberal. Permuting
%  the labels again at each timepoint gives temporally independent permuted
%  maps with null clusters that are too small.
%
%%  REFERENCES:
%
%  - Etzel, J. A., & Braver, T. S. (2013). MVPA permutation schemes:
%    permutation testing in the land of cross-validation. International
%    Workshop on Pattern Recognition in Neuroimaging, 140-143.
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
%  - {1D-array} - Y:
%    Labels of the dataset.
%
%%  OUTPUT:
%
%  - {1D-array} - Yp:
%    The same labels in a random order.

Yp = Y(randperm(numel(Y)));

end
