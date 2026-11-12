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
%  - Symmetry and diagonal: every RDM computed by MVPAlab is symmetric with
%    a zero diagonal, with or without cross-validation (the
%    cross-validated Pearson distance, mvpalab_cvpearson, and the
%    cross-validated Euclidean and crossnobis distances,
%    mvpalab_cveuclidean, are symmetric by construction and their diagonal
%    is exactly 0). The theoretical RDMs are defined by the user and could
%    be asymmetric, so both directions of each pair are averaged,
%    (rdm + rdm')/2, which has no effect on symmetric RDMs.
%
%  - The diagonal is left out: it would add cells in which every RDM is
%    zero and would inflate the correlation with any model.
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
