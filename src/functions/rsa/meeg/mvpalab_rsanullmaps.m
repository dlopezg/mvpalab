function [nullmaps,cfg] = mvpalab_rsanullmaps(cfg,res)
%% MVPALAB_RSANULLMAPS
%
%  This function returns the maps of the null distribution of the
%  permutation test of a time-resolved RSA (see mvpalab_rsa_time), the
%  input of mvpalab_permtest:
%
%  - Without cfg.stats.signflip, the permuted maps: for each subject,
%    cfg.stats.nper permutations of the conditions of its RDM, drawn once
%    and shared by all the models and timepoints (see mvpalab_permidx),
%    compared with the theoretical RDMs as the observed map (see
%    mvpalab_rsamaps). The RDMs come from the result, so the data is not
%    needed. They are saved with mvpalab_save.
%  - With cfg.stats.signflip, the sign flip maps around 0 (see
%    mvpalab_selectnull).
%
%  mvpalab_rsa_time calls it with cfg.stats.flag enabled, with its own cfg,
%  so the null maps always follow the settings of the result. To call it
%  separately, use the cfg returned by mvpalab_rsa_time.
%
%%  INPUT:
%
%  - {struct} - cfg:
%    Configuration structure returned by mvpalab_rsa_time.
%
%  - {struct} - res:
%    Result of mvpalab_rsa_time.
%
%%  OUTPUT:
%
%  - {struct} - nullmaps:
%    Maps of the null distribution of each model, as the result
%    [1 x timepoints x subjects x maps].
%
%  - {struct} - cfg:
%    Configuration structure.

cfg = mvpalab_updatecfg(cfg);
mvpalab_validatestats(cfg);
mvpalab_validatesignflip(cfg);

mode = cfg.rsa.modality;
dist = cfg.rsa.distance;

permaps = [];
if ~cfg.stats.signflip
    fprintf('\n<strong> > Computing RSA permuted maps: </strong>\n');
    rdms = res.(mode).(dist).rdms;
    theo = res.(mode).(dist).theo;
    permaps.(mode).(dist) = struct();
    for sub = 1 : numel(rdms)
        vrdm = mvpalab_vectorizerdm(rdms{sub});
        vtheo = permute(mvpalab_vectorizerdm(theo{sub}),[2 3 1]);
        pidx = mvpalab_permidx(size(vrdm,2),cfg.stats.nper);
        maps = mvpalab_rsamaps(cfg,vrdm,vtheo,pidx);
        permaps.(mode).(dist) = mvpalab_storersamaps(permaps.(mode).(dist),maps,sub);
    end
    mvpalab_save(cfg,permaps,'permaps');
end

nullmaps = mvpalab_selectnull(cfg,res,permaps,0);

end
