function pidx = mvpalab_permidx(cfg,nvec,nperm)
%% MVPALAB_PERMIDX
%
%  This function returns the permutation indexes used to compute the
%  permuted maps of the representational similarity analysis. Instead of
%  shuffling the cells of the vectorized RDM, the condition labels are
%  permuted, i.e. rows and columns of the RDM are reordered together:
%  rdm(p,p). This preserves the dependence structure between the cells
%  that share a condition. Each permutation is applied to all the
%  timepoints, so the permuted maps preserve the temporal autocorrelation
%  of the data and the cluster-based permutation test is not liberal.

%%  INPUT:
%
%  - {struct} cfg
%    Description: Configuration structure. cfg.cv.nfolds defines the
%    vectorization used by mvpalab_vectorizerdm: unique pairs
%    (squareform) if nfolds < 2, all the cells otherwise.
%
%  - {integer} nvec
%    Description: Length of the vectorized RDM.
%
%  - {integer} nperm
%    Description: Number of permutations.
%
%%  OUTPUT:
%
%  - {2D-matrix} pidx
%    Description: Indexes into the vectorized RDM. Row i is the vectorized
%    RDM permuted with the i-th permutation of the conditions:
%    vrdm(pidx(i,:)) - [permutations x vectorized]

%% Index matrix:
%  lin is a [conditions x conditions] matrix containing the position of
%  each cell in the vectorized RDM. Permuting the conditions of the RDM is
%  equivalent to permuting the rows and columns of lin.

if cfg.cv.nfolds < 2
    nconds = (1 + sqrt(1 + 8*nvec)) / 2;
    lin = squareform(1:nvec);
else
    nconds = sqrt(nvec);
    lin = reshape(1:nvec,nconds,nconds);
end

%% Number of different permutations:
%  If the number of conditions is small the same permutations are used
%  several times.

if factorial(nconds) < nperm
    warning(['Only %d different permutations of %d conditions. ' ...
        'Some permuted maps will be repeated.'],factorial(nconds),nconds);
end

%% Permutation loop:

pidx = zeros(nperm,nvec);

for perm = 1 : nperm
    p = randperm(nconds);
    lin_ = lin(p,p);
    if cfg.cv.nfolds < 2
        pidx(perm,:) = squareform(lin_);
    else
        pidx(perm,:) = lin_(:);
    end
end

end
