function [cfg,res,permaps,stats] = mvpalab_fusion(cfg,eeg_rdms,fmri_rdms)

%% Initialization;

cfg = mvpalab_checkcfg(cfg);
permaps = struct();
stats = struct();

%% Check the statistics:
%  In 'no-mean' each observation is a pair of subjects, so the observations
%  are not independent and the signs cannot be flipped.

mvpalab_checksignflip(cfg);
if cfg.stats.signflip && strcmp(cfg.fusion.mode,'no-mean')
    error('The sign flip test is not available in the ''no-mean'' fusion mode.');
end

%% Compute fusion:
%  Description:

if strcmp(cfg.fusion.mode,'mean-fmri')
    [cfg,result] = mvpalab_fusion_meanfmri(cfg,fmri_rdms,eeg_rdms);
    
elseif strcmp(cfg.fusion.mode,'mean-eeg')
    [cfg,result] = mvpalab_fusion_meaneeg(cfg,fmri_rdms,eeg_rdms);
    
elseif strcmp(cfg.fusion.mode,'no-mean')
    [cfg,result] = mvpalab_fusion_nomean(cfg,fmri_rdms,eeg_rdms);
    
end

%% Save results:
res.(cfg.fusion.distance) = result.res;
mvpalab_save(cfg,res,'res');

%% Compute permutation test:
%  If needed:

if cfg.stats.flag
    if cfg.stats.signflip
        permaps = mvpalab_signmaps(res,0);
    else
        permaps.(cfg.fusion.distance) = result.permaps;
    end
    stats.(cfg.fusion.distance) = mvpalab_permtest(cfg,res,permaps);
    
end

%% Save permuted maps:
%  If needed:

if cfg.stats.flag && ~cfg.stats.signflip
    mvpalab_save(cfg,permaps,'permaps');
end


end

