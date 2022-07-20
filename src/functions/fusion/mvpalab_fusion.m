function [cfg,res,permaps,stats] = mvpalab_fusion(cfg,eeg_rdms,fmri_rdms)

%% Initialization;

permaps = struct();
stats = struct();

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
    permaps.(cfg.fusion.distance) = result.permaps;
    stats.(cfg.fusion.distance) = mvpalab_permtest(cfg,res,permaps);
    
end

%% Save permuted maps:
%  If needed:

if cfg.stats.flag, mvpalab_save(cfg,permaps,'permaps'); end


end

