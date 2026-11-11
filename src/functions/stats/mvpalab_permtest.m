function stats = mvpalab_permtest(cfg,results,nullmaps)
%% MVPALAB_PERMTEST
%
%  This function computes the permutation test of every map of results
%  that has maps of the null distribution in nullmaps, with
%  mvpalab_computepermtest. It iterates over the fields of both structures
%  (local function testfields). Cell arrays are not maps: an RSA model can
%  share its name with the RDMs.
%
%  The null maps of the subjects are combined at group level as set in
%  nullmaps.pairing: 'shared' when map k of every subject uses the same
%  permutation, as in the M/EEG-fMRI fusion (see mvpalab_fusionnullmaps),
%  or at random otherwise (Stelzer et al., 2013), when nullmaps has no
%  field pairing. The pairing travels with the null maps, so the test
%  cannot be run with the wrong one.
%
%  All the analyses run it after they compute their result and its null
%  maps, with the cfg returned by the analysis. The statistics are saved
%  with mvpalab_save in cfg.savefolder, next to the results.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure.
%
%  - {struct} - results:
%    Data structure containing the results for each measure.
%
%  - {struct} - nullmaps:
%    Maps of the null distribution for each measure: the permuted maps or,
%    with cfg.stats.signflip, the maps of the sign flip test (see
%    mvpalab_selectnull), and optionally the field pairing.
%
%%  OUTPUT:
%
%  - {struct} - stats:
%    The same fields as results that have maps in nullmaps, with the output
%    of mvpalab_computepermtest for each map.

pairing = 'random';
if isstruct(nullmaps) && isfield(nullmaps,'pairing'), pairing = nullmaps.pairing; end

stats = testfields(cfg,results,nullmaps,pairing,'acc');

fprintf('\n<strong> > Permutation test finished!</strong>\n\n');
mvpalab_save(cfg,stats,'stats');

end

function stats = testfields(cfg,results,nullmaps,pairing,fname)
%% The test of each map with maps of the null distribution, field by field.

if isstruct(results)
    for field = fieldnames(results)'
        fname = field{1};
        if isfield(nullmaps,fname) && ~iscell(results.(fname))
            stats.(fname) = testfields(cfg,results.(fname),...
                nullmaps.(fname),pairing,fname);
        end
    end
else
    fprintf(['\n<strong> > Permutation test (' fname '): </strong>\n']);
    stats = mvpalab_computepermtest(cfg,results,nullmaps,pairing);
end

end
