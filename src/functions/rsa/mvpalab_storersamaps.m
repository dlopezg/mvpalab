function stored = mvpalab_storersamaps(stored,maps,sub)
%% MVPALAB_STORERSAMAPS
%
%  This function stores the maps of one subject of an RSA (see
%  mvpalab_rsamaps) in the result or the null maps, in each field of the
%  maps: one row per subject in the third dimension and, with more than
%  one map, one map per permutation in the fourth one. mvpalab_rsa_time
%  stores the observed maps and mvpalab_rsanullmaps the permuted maps.
%
%%  INPUT:
%
%  - {struct} - stored:
%    Maps stored so far, with the same fields as maps.
%
%  - {struct} - maps:
%    Maps of the subject [timepoints x maps] in each field.
%
%  - {int} - sub:
%    Subject.
%
%%  OUTPUT:
%
%  - {struct} - stored:
%    The same structure with the maps of the subject: [1 x timepoints x
%    subjects] for one map, [1 x timepoints x subjects x maps] for more.

if isstruct(maps)
    for field = fieldnames(maps)'
        name = field{1};
        if ~isfield(stored,name), stored.(name) = []; end
        stored.(name) = mvpalab_storersamaps(stored.(name),maps.(name),sub);
    end
    return
end

if size(maps,2) == 1
    stored(1,:,sub) = maps';
else
    stored(1,:,sub,:) = permute(maps,[3 1 4 2]);
end

end
