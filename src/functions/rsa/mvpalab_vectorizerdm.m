function vrdm = mvpalab_vectorizerdm(rdm)
%% MVPALAB_VECTORIZERDM
%
%  This function returns the vectorized version of a temporal series of
%  RDMs in the form: [timepoints x vectorizedrdm x models]
%
%  Each RDM is reduced to its unique pairs of conditions (the lower
%  triangle without the diagonal, squareform order). This is the same for
%  empirical and theoretical RDMs and with or without cross-validation, so
%  all the vectorized RDMs share the same layout and length:
%  n*(n-1)/2, where n is the number of conditions (or trials).
%
%  - Symmetry: without cross-validation the RDMs are symmetric. With
%    cross-validation the dissimilarity between two conditions is computed
%    between independent partitions (training and test) of the data.
%    The cross-validated Pearson distance (mvpalab_cvpearson) is symmetric
%    by construction, but other measures computed from training to test
%    patterns, e.g. pdist2(train,test), are not: rdm(i,j) and rdm(j,i) are
%    two estimates of the same dissimilarity obtained from different data.
%    Both estimates are averaged, (rdm + rdm')/2, so each pair of
%    conditions enters the analysis once. This has no effect on symmetric
%    RDMs.
%
%  - Diagonal: without cross-validation the diagonal is zero by
%    definition. With cross-validation it compares two independent
%    estimates of the same condition, i.e. it measures the reliability of
%    the pattern of each condition, which is a different quantity than
%    the dissimilarity between conditions. It is removed from the
%    vectorized RDMs (it is kept in the RDMs returned by mvpalab_rdm).
%    Keeping it would add cells in which every theoretical model has its
%    minimum value (zero) and would inflate the correlation with any model.
%
%  Other toolboxes also return only the unique pairs of conditions for
%  cross-validated RDMs, e.g. MNE-RSA (compute_rdm_cv, upper triangle
%  without the diagonal) and rsatoolbox (calc_rdm, crossnobis).
%
%%  INPUT:
%
%  - {matrix} - rdm:
%    RDMs [conditions x conditions x timepoints x models].
%
%%  OUTPUT:
%
%  - {matrix} - vrdm:
%    Vectorized RDMs [timepoints x pairs x models].

[n,~,ntp,nmodels] = size(rdm);

% Both directions of each pair:
rdm = (rdm + permute(rdm,[2 1 3 4]))/2;

% Lower triangle without the diagonal, in the order of squareform:
pairs = tril(true(n),-1);
vrdm = reshape(rdm,n*n,ntp*nmodels);
vrdm = reshape(vrdm(pairs(:),:),[],ntp,nmodels);
vrdm = permute(vrdm,[2 1 3]);

end
