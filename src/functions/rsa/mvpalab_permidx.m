function pidx = mvpalab_permidx(nvec,nperm)
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
%
%%  INPUT:
%
%  - {int} - nvec:
%    Length of the vectorized RDM. The RDMs are vectorized by
%    mvpalab_vectorizerdm as unique pairs of conditions (squareform), so
%    nvec = n*(n-1)/2 for n conditions.
%
%  - {int} - nperm:
%    Number of permutations.
%
%%  OUTPUT:
%
%  - {matrix} - pidx:
%    Indexes into the vectorized RDM [permutations x nvec]. Row i is the
%    vectorized RDM permuted with the i-th permutation of the conditions:
%    vrdm(pidx(i,:)).

%% Index matrix:
%  lin is a [conditions x conditions] matrix containing the position of
%  each cell in the vectorized RDM. Permuting the conditions of the RDM is
%  equivalent to permuting the rows and columns of lin.

nconds = (1 + sqrt(1 + 8*nvec)) / 2;
lin = squareform(1:nvec);

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
    pidx(perm,:) = squareform(lin(p,p));
end

end
