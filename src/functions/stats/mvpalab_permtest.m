function stats = mvpalab_permtest(cfg,res,nullmaps)
%% MVPALAB_PERMTEST
%
%  This function computes the permutation test of every map of res
%  that has maps of the null distribution in nullmaps, with
%  mvpalab_computepermtest. It iterates over the fields of both structures
%  (local function testfields), so the fields of the result without null
%  maps, such as the RDMs of an RSA, are left out.
%
%  The null maps of the subjects are combined at group level as set in
%  cfg.stats.pairing: 'shared' when map k of every subject uses the same
%  permutation, as in the M/EEG-fMRI fusion (see mvpalab_fusionnullmaps),
%  or 'random' (Stelzer et al., 2013) in the other analyses. Each analysis
%  sets it at the start, so it is in the cfg of every file it saves
%  (results, permuted maps and statistics): the test of maps loaded from
%  disk uses the right pairing with the cfg of any of these files.
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
%  - {struct} - res:
%    Data structure containing the results for each measure.
%
%  - {struct} - nullmaps:
%    Maps of the null distribution for each measure: the permuted maps or,
%    with cfg.stats.signflip, the maps of the sign flip test (see
%    mvpalab_selectnull).
%
%%  OUTPUT:
%
%  - {struct} - stats:
%    The same fields as res that have maps in nullmaps, with the output
%    of mvpalab_computepermtest for each map.

cfg = mvpalab_updatecfg(cfg);

stats = testfields(cfg,res,nullmaps,'acc');

fprintf('\n<strong> > Permutation test finished!</strong>\n\n');
mvpalab_save(cfg,stats,'stats');

end

function stats = testfields(cfg,res,nullmaps,fname)
%% The test of each map with maps of the null distribution, field by field.

if isstruct(res)
    for field = fieldnames(res)'
        fname = field{1};
        if isfield(nullmaps,fname)
            stats.(fname) = testfields(cfg,res.(fname),...
                nullmaps.(fname),fname);
        end
    end
else
    fprintf(['\n<strong> > Permutation test (' fname '): </strong>\n']);
    stats = mvpalab_computepermtest(cfg,res,nullmaps);
end

end
